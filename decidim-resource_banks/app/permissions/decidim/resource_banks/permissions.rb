# frozen_string_literal: true

module Decidim
  module ResourceBanks
    class Permissions < Decidim::DefaultPermissions
      def permissions
        user_can_enter_space_area?

        return permission_action if resource_bank && !resource_bank.is_a?(Decidim::ResourceBank)

        if read_admin_dashboard_action?
          user_can_read_admin_dashboard?
          return permission_action
        end

        if permission_action.scope == :public
          public_list_resource_banks_action?
          public_read_resource_bank_action?
          public_report_content_action?
          return permission_action
        end

        return permission_action unless user

        if !has_manageable_resource_banks? && !user.admin?
          disallow!
          return permission_action
        end

        return permission_action unless permission_action.scope == :admin

        user_can_read_resource_bank_list?
        user_can_list_resource_bank_list?
        user_can_read_current_resource_bank?
        user_can_create_resource_bank?

        # org admins and space admins can do everything in the admin section
        org_admin_action?

        return permission_action unless resource_bank

        resource_bank_admin_action?

        permission_action
      end

      # It's an admin user if it's an organization admin or is a space admin
      # for the current `resource_bank`.
      def admin_user?
        user.admin? || (resource_bank ? can_manage_resource_bank?(role: :admin) : has_manageable_resource_banks?)
      end

      # Checks if it has any manageable resource_bank, with any possible role.
      def has_manageable_resource_banks?(role: :any) # rubocop:disable Naming/PredicateName
        return unless user

        resource_banks_with_role_privileges(role).any?
      end

      # Whether the user can manage the given resource_bank or not.
      def can_manage_resource_bank?(role: :any)
        return unless user

        resource_banks_with_role_privileges(role).include? resource_bank
      end

      # Returns a collection of resource_banks where the given user has the
      # specific role privilege.
      def resource_banks_with_role_privileges(role)
        Decidim::ResourceBanks::ResourceBanksWithUserRole.for(user, role)
      end

      def public_list_resource_banks_action?
        return unless permission_action.action == :list &&
                      permission_action.subject == :resource_bank

        allow!
      end

      def public_read_resource_bank_action?
        return unless permission_action.action == :read &&
                      [:resource_bank, :participatory_space].include?(permission_action.subject) &&
                      resource_bank

        return allow! if user&.admin?
        return allow! if resource_bank.published?

        toggle_allow(can_manage_resource_bank?)
      end

      def public_report_content_action?
        return unless permission_action.action == :create &&
                      permission_action.subject == :moderation

        allow!
      end

      # All users with a relation to a resource_bank and organization admins can enter
      # the space area. The space area is considered to be the resource_banks zone.
      def user_can_enter_space_area?
        return unless permission_action.action == :enter &&
                      permission_action.scope == :admin &&
                      permission_action.subject == :space_area &&
                      context.fetch(:space_name, nil) == :resource_banks

        toggle_allow(user.admin? || has_manageable_resource_banks?)
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
        allow! if user.admin? || has_manageable_resource_banks?
      end

      # Only organization admins can create a resource_bank
      def user_can_create_resource_bank?
        return unless permission_action.action == :create &&
                      permission_action.subject == :resource_bank

        toggle_allow(user.admin?)
      end

      # Everyone can read the resource_bank list
      def user_can_read_resource_bank_list?
        return unless read_resource_bank_list_permission_action?

        toggle_allow(user.admin? || has_manageable_resource_banks?)
      end

      # Checks whether the user can list the current given resource_bank or not.
      def user_can_list_resource_bank_list?
        return unless permission_action.action == :list &&
                      permission_action.subject == :resource_bank

        toggle_allow(user.admin? || allowed_list_of_resource_banks?)
      end

      def allowed_list_of_resource_banks?
        ResourceBanksWithUserRole.for(user).uniq.member?(resource_bank)
      end

      def user_can_read_current_resource_bank?
        return unless read_resource_bank_list_permission_action?
        return if permission_action.subject == :resource_bank_list

        toggle_allow(user.admin? || can_manage_resource_bank?)
      end

      # ResourceBank admins can perform everything *inside* that resource_bank. They cannot
      # create a resource_bank or perform actions on resource_bank groups or other
      # resource_banks.
      def resource_bank_admin_action?
        return unless can_manage_resource_bank?(role: :admin)
        return if user.admin?
        return disallow! if permission_action.action == :create &&
                            permission_action.subject == :resource_bank

        is_allowed = [
          :attachment,
          :attachment_collection,
          :category,
          :component,
          :component_data,
          :resource_bank,
          :resource_bank_user_role
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
          :resource_bank,
          :resource_bank_user_role
        ].include?(permission_action.subject)

        allow! if is_allowed
      end

      # Checks if the permission_action is to read the admin resource_banks list or
      # not.
      def read_resource_bank_list_permission_action?
        permission_action.action == :read &&
          [:resource_bank, :participatory_space, :resource_bank_list].include?(permission_action.subject)
      end

      def resource_bank
        @resource_bank ||= context.fetch(:current_participatory_space, nil) || context.fetch(:resource_bank, nil)
      end
    end
  end
end
