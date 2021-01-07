# frozen_string_literal: true

module Decidim
  module Courses
    class Permissions < Decidim::DefaultPermissions
      def permissions
        user_can_enter_space_area?

        return permission_action if course && !course.is_a?(Decidim::Course)

        if read_admin_dashboard_action?
          user_can_read_admin_dashboard?
          return permission_action
        end

        if permission_action.scope == :public
          public_list_courses_action?
          public_read_course_action?
          public_report_content_action?
          return permission_action
        end

        return permission_action unless user

        unless user.admin?
          disallow!
          return permission_action
        end

        return permission_action unless permission_action.scope == :admin

        user_can_read_course_list?
        user_can_read_current_course?
        user_can_create_course?

        # org admins and space admins can do everything in the admin section
        org_admin_action?

        permission_action
      end

      def public_list_courses_action?
        return unless permission_action.action == :list &&
                      permission_action.subject == :course

        allow!
      end

      def public_read_course_action?
        return unless permission_action.action == :read &&
                      [:course, :participatory_space].include?(permission_action.subject) &&
                      course

        return allow! if course.published?

        toggle_allow(user&.admin?)
      end

      def public_report_content_action?
        return unless permission_action.action == :create &&
                      permission_action.subject == :moderation

        allow!
      end

      # All users with a relation to a course and organization admins can enter
      # the space area. The space area is considered to be the courses zone.
      def user_can_enter_space_area?
        return unless permission_action.action == :enter &&
                      permission_action.scope == :admin &&
                      permission_action.subject == :space_area &&
                      context.fetch(:space_name, nil) == :courses

        toggle_allow(user.admin?)
      end

      # Checks if the permission_action is to read in the admin or not.
      def admin_read_permission_action?
        permission_action.action == :read
      end

      def read_admin_dashboard_action?
        permission_action.action == :read &&
          permission_action.subject == :admin_dashboard
      end

      # Any user that can enter the space area can read the admin dashboard.
      def user_can_read_admin_dashboard?
        allow! if user.admin?
      end

      # Only organization admins can create a course
      def user_can_create_course?
        return unless permission_action.action == :create &&
                      permission_action.subject == :course

        toggle_allow(user.admin?)
      end

      # Everyone can read the course list
      def user_can_read_course_list?
        return unless read_course_list_permission_action?

        toggle_allow(user.admin?)
      end

      def user_can_read_current_course?
        return unless read_course_list_permission_action?
        return if permission_action.subject == :course_list

        toggle_allow(user.admin?)
      end

      def org_admin_action?
        return unless user.admin?

        is_allowed = [
          :attachment,
          :attachment_collection,
          :category,
          :component,
          :component_data,
          :course,
          :export_space
        ].include?(permission_action.subject)

        allow! if is_allowed
      end

      # Checks if the permission_action is to read the admin courses list or
      # not.
      def read_course_list_permission_action?
        permission_action.action == :read &&
          [:course, :participatory_space, :course_list].include?(permission_action.subject)
      end

      def course
        @course ||= context.fetch(:current_participatory_space, nil) || context.fetch(:course, nil)
      end
    end
  end
end
