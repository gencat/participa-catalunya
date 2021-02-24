# frozen_string_literal: true

require_dependency "decidim/admin/application_controller"

module Decidim
  module Courses
    module Admin
      # Controller that allows inviting users to join a course.
      #
      class CourseInvitesController < Decidim::Courses::Admin::ApplicationController
        include Concerns::CourseAdmin

        helper_method :course

        def index
          enforce_permission_to :read_invites, :course, course: course

          @query = params[:q]
          @status = params[:status]
          @course_invites = Decidim::Courses::Admin::CourseInvites.for(course.course_invites, @query, @status).page(params[:page]).per(15)
        end

        def new
          enforce_permission_to :invite_attendee, :course, course: course

          @form = form(CourseRegistrationInviteForm).instance
        end

        def create
          enforce_permission_to :invite_attendee, :course, course: course

          @form = form(CourseRegistrationInviteForm).from_params(params)

          InviteUserToJoinCourse.call(@form, course, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("course_invites.create.success", scope: "decidim.courses.admin")
              redirect_to course_course_invites_path(course)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("course_invites.create.error", scope: "decidim.courses.admin")
              render :new
            end
          end
        end

        private

        def course
          @course ||= Decidim::Course.find_by(slug: params[:course_slug])
        end
      end
    end
  end
end
