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
          public_list_registration_types_action?
          public_report_content_action?

          can_join_course?
          can_leave_course?
          can_decline_invitation?

          return permission_action
        end

        return permission_action unless user

        if !has_manageable_courses? && !user.admin?
          disallow!
          return permission_action
        end

        return permission_action unless permission_action.scope == :admin

        user_can_read_course_list?
        user_can_list_course_list?
        user_can_read_current_course?
        user_can_read_course_registrations?
        user_can_export_course_registrations?
        user_can_confirm_course_registration?
        user_can_create_course?
        user_can_export_course?

        # org admins and space admins can do everything in the admin section
        org_admin_action?

        return permission_action unless course

        course_admin_action?

        permission_action
      end

      # It's an admin user if it's an organization admin or is a space admin
      # for the current `course`.
      def admin_user?
        user.admin? || (course ? can_manage_course?(role: :admin) : has_manageable_courses?)
      end

      # Checks if it has any manageable course, with any possible role.
      def has_manageable_courses?(role: :any) # rubocop:disable Naming/PredicateName
        return unless user

        courses_with_role_privileges(role).any?
      end

      # Whether the user can manage the given course or not.
      def can_manage_course?(role: :any)
        return unless user

        courses_with_role_privileges(role).include? course
      end

      # Returns a collection of courses where the given user has the
      # specific role privilege.
      def courses_with_role_privileges(role)
        Decidim::Courses::CoursesWithUserRole.for(user, role)
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

        return allow! if user&.admin?
        return allow! if course.published?

        toggle_allow(can_manage_course?)
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

        toggle_allow(user.admin? || has_manageable_courses?)
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
        allow! if user.admin? || has_manageable_courses?
      end

      # Only organization admins can create a course
      def user_can_create_course?
        return unless permission_action.action == :create &&
                      permission_action.subject == :course

        toggle_allow(user.admin?)
      end

      # Only organization admins can read a course registrations
      def user_can_read_course_registrations?
        return unless permission_action.action == :read_course_registrations &&
                      permission_action.subject == :course

        toggle_allow(user.admin?)
      end

      # Only organization admins can export a course registrations
      def user_can_export_course_registrations?
        return unless permission_action.action == :export_course_registrations &&
                      permission_action.subject == :course

        toggle_allow(user.admin?)
      end

      # Everyone can read the course list
      def user_can_read_course_list?
        return unless read_course_list_permission_action?

        toggle_allow(user.admin? || has_manageable_courses?)
      end

      # Checks whether the user can list the current given course or not.
      def user_can_list_course_list?
        return unless permission_action.action == :list &&
                      permission_action.subject == :course

        toggle_allow(user.admin? || allowed_list_of_courses?)
      end

      def public_list_registration_types_action?
        return unless permission_action.action == :list &&
                      permission_action.subject == :registration_types

        allow!
      end

      def allowed_list_of_courses?
        CoursesWithUserRole.for(user).uniq.member?(course)
      end

      def user_can_confirm_course_registration?
        return unless permission_action.action == :confirm &&
                      permission_action.subject == :course_registration

        toggle_allow(user.admin?)
      end

      def user_can_read_current_course?
        return unless read_course_list_permission_action?
        return if permission_action.subject == :course_list

        toggle_allow(user.admin? || can_manage_course?)
      end

      # Course admins can perform everything *inside* that course. They cannot
      # create a course or perform actions on course groups or other
      # courses.
      def course_admin_action?
        return unless can_manage_course?(role: :admin)
        return if user.admin?
        return disallow! if permission_action.action == :create &&
                            permission_action.subject == :course

        is_allowed = [
          :attachment,
          :attachment_collection,
          :category,
          :component,
          :component_data,
          :course,
          :course_user_role,
          :course_invite,
          :course_registration,
          :registration_type
        ].include?(permission_action.subject)

        allow! if is_allowed
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
          :export_space,
          :course_user_role,
          :course_invite,
          :course_registration,
          :registration_type,
          :read_course_registrations,
          :export_course_registrations
        ].include?(permission_action.subject)

        allow! if is_allowed
      end

      def can_join_course?
        return unless course.presence
        return unless course.registrations_enabled? &&
                      permission_action.action == :join &&
                      permission_action.subject == :course

        allow!
      end

      def can_leave_course?
        return unless course.presence
        return unless course.registrations_enabled? &&
                      permission_action.action == :leave &&
                      permission_action.subject == :course

        allow!
      end

      def can_decline_invitation?
        return unless course.presence
        return unless course.registrations_enabled? &&
                      course.course_invites.where(user: user).exists? &&
                      permission_action.action == :decline_invitation &&
                      permission_action.subject == :course

        allow!
      end

      def user_can_export_course?
        allow! if (permission_action.subject == :courses || permission_action.subject == :course) && permission_action.action == :export
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
