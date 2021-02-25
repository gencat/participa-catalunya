# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # This command is executed when the user exports the registrations of
      # a Course from the admin panel.
      class ExportCourseRegistrations < Rectify::Command
        # course - The current instance of the course that holds the registrations.
        # format - a string representing the export format
        # current_user - the user performing the action
        def initialize(course, format, current_user)
          @course = course
          @format = format
          @current_user = current_user
        end

        # Exports the course registrations.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          broadcast(:ok, export_data)
        end

        private

        attr_reader :current_user, :course, :format

        def export_data
          Decidim.traceability.perform_action!(
            :export_course_registrations,
            course,
            current_user
          ) do
            Decidim::Exporters
              .find_exporter(format)
              .new(course.course_registrations, Decidim::Courses::CourseRegistrationSerializer)
              .export
          end
        end
      end
    end
  end
end
