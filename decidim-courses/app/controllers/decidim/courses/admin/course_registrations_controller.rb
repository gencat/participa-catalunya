# frozen_string_literal: true

require_dependency "decidim/admin/application_controller"

module Decidim
  module Courses
    module Admin
      # Controller that allows to manage the course users registrations.
      #
      class CourseRegistrationsController < Decidim::Courses::Admin::ApplicationController
        include Concerns::CourseAdmin
        include Decidim::Paginable

        helper_method :course

        def index
          enforce_permission_to :read_course_registrations, :course, course: course

          @course_registrations = paginate(Decidim::Courses::CourseRegistration.where(course: course))
        end

        def export
          enforce_permission_to :export_course_registrations, :course, course: course

          ExportCourseRegistrations.call(course, params[:format], current_user) do
            on(:ok) do |export_data|
              send_data export_data.read, type: "text/#{export_data.extension}", filename: export_data.filename("course_registrations")
            end
          end
        end

        def confirm
          enforce_permission_to :confirm, :course_registration, course_registration: course_registration

          ConfirmCourseRegistration.call(course_registration, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("course_registration.confirm.success", scope: "decidim.admin")
            end

            on(:invalid) do
              flash[:alert] = I18n.t("course_registration.confirm.error", scope: "decidim.admin")
            end

            redirect_back(fallback_location: course_course_registrations_path)
          end
        end

        private

        def course
          @course ||= Decidim::Course.find_by(slug: params[:course_slug])
        end

        def course_registration
          return if params[:id].blank?

          @course_registration ||= course.course_registrations.find_by(id: params[:id])
        end
      end
    end
  end
end
