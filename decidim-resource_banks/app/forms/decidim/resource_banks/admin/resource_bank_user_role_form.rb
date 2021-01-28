# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A form object used to create resource_bank user roles from the admin dashboard.
      #
      class ResourceBankUserRoleForm < Form
        mimic :resource_bank_user_role

        attribute :name, String
        attribute :email, String
        attribute :role, String

        validates :name, :email, :role, presence: true
        validates :role, inclusion: { in: Decidim::ResourceBankUserRole::ROLES }

        validates :name, format: { with: UserBaseEntity::REGEXP_NAME }

        def roles
          Decidim::ResourceBankUserRole::ROLES.map do |role|
            [
              I18n.t(role, scope: "decidim.admin.models.resource_bank_user_role.roles"),
              role
            ]
          end
        end
      end
    end
  end
end
