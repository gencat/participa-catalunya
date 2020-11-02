# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A command that sets a course as unpublished.
      class UnpublishCourse < Rectify::Command
        # Public: Initializes the command.
        #
        # course - A Course that will be published
        # current_user - the user performing the action
        def initialize(course, current_user)
          @course = course
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the data wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if course.nil? || !course.published?

          Decidim.traceability.perform_action!("unpublish", course, current_user) do
            course.unpublish!
          end

          broadcast(:ok)
        end

        private

        attr_reader :course, :current_user
      end
    end
  end
end
