# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # This controller is the main admin controller for resource_banks
      class ApplicationController < Decidim::Admin::ApplicationController
        register_permissions(::Decidim::ResourceBanks::Admin::ApplicationController,
                             Decidim::ResourceBanks::Permissions,
                             Decidim::Admin::Permissions)

        private

        def permissions_context
          super.merge(
            current_participatory_space: try(:current_participatory_space)
          )
        end

        def permission_class_chain
          ::Decidim.permissions_registry.chain_for(::Decidim::ResourceBanks::Admin::ApplicationController)
        end
      end
    end
  end
end
