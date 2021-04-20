# frozen_string_literal: true

Decidim::Courses::Permissions.class_eval do
  alias_method :check_default_permissions, :permissions

  def permissions
    if department_admin_has_permission?
      allow!
      return permission_action
    end

    check_default_permissions
  end

  def department_admin_has_permission?
    department_admin_permission = permission_action.scope == :admin || permission_action.matches?(:public, :read, :admin_dashboard)
    return unless department_admin_permission && user&.department_admin?

    # Check permissions set in gem (attachments, categories, ...)
    allowed = Decidim::DepartmentAdmin::Permissions
              .new(user, permission_action, context)
              .has_permission?(permission_action)

    allowed ||= permission_action.matches?(:admin, :read, :participatory_space) &&
                context[:current_participatory_space].class.name == "Decidim::Course"

    allowed ||= [
      # space
      [:admin, :read, :participatory_space],
      # courses
      [:admin, :enter, :space_area, space_name: :courses],
      [:admin, :read, :course_list],
      [:admin, :create, :course],
      # course_admins
      [:admin, :index, :course_user_role],
      [:admin, :read, :course_user_role],
      [:admin, :create, :course_user_role],
      [:admin, :update, :course_user_role],
      [:admin, :invite, :course_user_role],
      [:admin, :destroy, :course_user_role]
    ].any? { |permission| matches_permission?(permission) }

    allowed ||= [
      # courses
      [:admin, :update, :course],
      [:admin, :publish, :course],
      [:admin, :unpublish, :course],
      [:admin, :export, :course]
    ].any? { |permission| matches_permission_and_area?(permission) }

    allowed
  end

  private

  def matches_permission?(permission)
    scope, action, subject, *expected_context = permission

    permission_action.matches?(scope, action, subject) &&
      (expected_context || {}).all? do |key, expected_value|
        (context.try(:[], key) == expected_value)
      end
  end

  def matches_permission_and_area?(permission)
    matches_permission?(permission) && in_same_area?
  end

  def in_same_area?
    user.areas.compact.include? course&.area
  end
end
