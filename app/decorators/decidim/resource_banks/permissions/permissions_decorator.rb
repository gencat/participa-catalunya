# frozen_string_literal: true

Decidim::ResourceBanks::Permissions.class_eval do
  alias_method :check_default_permissions, :permissions

  def permissions
    if department_admin_has_permission?
      allow!
      return permission_action
    end

    check_default_permissions
  end

  def department_admin_has_permission?
    return unless permission_action.scope == :admin && user&.department_admin?

    # Check permissions set in gem (attachments, categories, ...)
    allowed = Decidim::DepartmentAdmin::Permissions
              .new(user, permission_action, context)
              .has_permission?(permission_action)

    allowed ||= permission_action.matches?(:admin, :read, :participatory_space) &&
                context[:current_participatory_space].class.name == "Decidim::ResourceBank"

    allowed ||= [
      # space
      [:admin, :read, :participatory_space],
      # resource_banks
      [:admin, :enter, :space_area, space_name: :resource_banks],
      [:admin, :read, :resource_bank_list],
      [:admin, :create, :resource_bank],
      # resource_bank_admins
      [:admin, :index, :resource_bank_user_role],
      [:admin, :read, :resource_bank_user_role],
      [:admin, :create, :resource_bank_user_role],
      [:admin, :update, :resource_bank_user_role],
      [:admin, :invite, :resource_bank_user_role],
      [:admin, :destroy, :resource_bank_user_role]
    ].any? { |permission| matches_permission?(permission) }

    allowed ||= [
      # resource_banks
      [:admin, :update, :resource_bank],
      [:admin, :publish, :resource_bank],
      [:admin, :unpublish, :resource_bank],
      [:admin, :export, :resource_bank]
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
    user.areas.compact.include? resource_bank&.area
  end
end
