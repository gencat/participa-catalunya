# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # Controller that allows managing course user roles.
      #
      class CourseUserRolesController < Decidim::Courses::Admin::ApplicationController
        include Concerns::CourseAdmin

        def index
          enforce_permission_to :index, :course_user_role
          @course_user_roles = collection
        end

        def new
          enforce_permission_to :create, :course_user_role
          @form = form(CourseUserRoleForm).instance
        end

        def create
          enforce_permission_to :create, :course_user_role
          @form = form(CourseUserRoleForm).from_params(params)

          CreateCourseAdmin.call(@form, current_user, current_course) do
            on(:ok) do
              flash[:notice] = I18n.t("course_user_roles.create.success", scope: "decidim.admin")
              redirect_to course_user_roles_path(current_course)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("course_user_roles.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          @user_role = collection.find(params[:id])
          enforce_permission_to :update, :course_user_role, user_role: @user_role
          @form = form(CourseUserRoleForm).from_model(@user_role.user)
        end

        def update
          @user_role = collection.find(params[:id])
          enforce_permission_to :update, :course_user_role, user_role: @user_role
          @form = form(CourseUserRoleForm).from_params(params)

          UpdateCourseAdmin.call(@form, @user_role) do
            on(:ok) do
              flash[:notice] = I18n.t("course_user_roles.update.success", scope: "decidim.admin")
              redirect_to course_user_roles_path(current_course)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("course_user_roles.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        def destroy
          @course_user_role = collection.find(params[:id])
          enforce_permission_to :destroy, :course_user_role, user_role: @course_user_role

          DestroyCourseAdmin.call(@course_user_role, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("course_user_roles.destroy.success", scope: "decidim.admin")
              redirect_to course_user_roles_path(current_course)
            end
          end
        end

        def resend_invitation
          @user_role = collection.find(params[:id])
          enforce_permission_to :invite, :course_user_role, user_role: @user_role

          InviteUserAgain.call(@user_role.user, "invite_admin") do
            on(:ok) do
              flash[:notice] = I18n.t("users.resend_invitation.success", scope: "decidim.admin")
            end

            on(:invalid) do
              flash[:alert] = I18n.t("users.resend_invitation.error", scope: "decidim.admin")
            end
          end

          redirect_to course_user_roles_path(current_course)
        end

        private

        def collection
          @collection ||= Decidim::CourseUserRole
                          .includes(:user)
                          .where(course: current_course)
                          .order(:role, "decidim_users.name")
        end
      end
    end
  end
end
