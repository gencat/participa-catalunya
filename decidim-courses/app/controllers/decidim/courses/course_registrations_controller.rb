# frozen_string_literal: true

module Decidim
  module Courses
    # Exposes the registration resource so users can join and leave courses.
    class CourseRegistrationsController < Decidim::Courses::ApplicationController
      def create
        enforce_permission_to :join, :course, course: course

        JoinCourse.call(course, registration_type, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("course_registrations.create.success", scope: "decidim.courses")
            redirect_after_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("course_registrations.create.invalid", scope: "decidim.courses")
            redirect_after_path
          end
        end
      end

      def destroy
        enforce_permission_to :leave, :course, course: course

        LeaveCourse.call(course, registration_type, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("course_registrations.destroy.success", scope: "decidim.courses")
            redirect_after_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("course_registrations.destroy.invalid", scope: "decidim.courses")
            redirect_after_path
          end
        end
      end

      def decline_invitation
        enforce_permission_to :decline_invitation, :course, course: course

        DeclineInvitation.call(course, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("course_registrations.decline_invitation.success", scope: "decidim.courses")
            redirect_after_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("course_registrations.decline_invitation.invalid", scope: "decidim.courses")
            redirect_after_path
          end
        end
      end

      private

      def course
        @course ||= Course.find_by(slug: params[:course_slug])
      end

      def registration_type
        course.registration_types.find_by(id: params[:registration_type_id])
      end

      def redirect_after_path
        referer = request.headers["Referer"]
        return redirect_to(course_path(course)) if referer =~ /invitation_token/

        redirect_back fallback_location: course_path(course)
      end
    end
  end
end
