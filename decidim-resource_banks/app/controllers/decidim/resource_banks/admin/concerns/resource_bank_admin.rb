# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module ResourceBanks
    module Admin
      module Concerns
        # This concern is meant to be included in all controllers that are scoped
        # into an resource_bank's admin panel. It will override the layout so it shows
        # the sidebar, preload the resource_bank, etc.
        module ResourceBankAdmin
          extend ActiveSupport::Concern

          RegistersPermissions
            .register_permissions(::Decidim::ResourceBanks::Admin::Concerns::ResourceBankAdmin,
                                  Decidim::ResourceBanks::Permissions,
                                  Decidim::Admin::Permissions)

          included do
            include Decidim::Admin::ParticipatorySpaceAdminContext
            participatory_space_admin_layout

            helper_method :current_resource_bank

            def current_resource_bank
              @current_resource_bank ||= organization_resource_banks.find_by!(
                slug: params[:resource_bank_slug] || params[:slug]
              )
            end

            alias_method :current_participatory_space, :current_resource_bank

            def organization_resource_banks
              @organization_resource_banks ||= OrganizationResourceBanks.new(current_organization).query
            end

            def permissions_context
              super.merge(current_participatory_space: current_participatory_space)
            end

            def permission_class_chain
              PermissionsRegistry.chain_for(ResourceBankAdmin)
            end
          end
        end
      end
    end
  end
end
