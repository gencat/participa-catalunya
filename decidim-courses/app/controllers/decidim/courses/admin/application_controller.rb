# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # This controller is the main admin controller for courses
      class ApplicationController < Decidim::Admin::ApplicationController
        register_permissions(::Decidim::Courses::Admin::ApplicationController,
                             Decidim::Courses::Permissions,
                             Decidim::Admin::Permissions)

        private

        def permissions_context
          super.merge(
            current_participatory_space: try(:current_participatory_space)
          )
        end

        def permission_class_chain
          ::Decidim.permissions_registry.chain_for(::Decidim::Courses::Admin::ApplicationController)
        end
      end
    end
  end
end
