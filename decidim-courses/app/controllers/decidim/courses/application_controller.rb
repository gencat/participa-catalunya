# frozen_string_literal: true

module Decidim
  module Courses
    # This controller is the abstract class from which all other controllers of
    # this engine inherit.
    #
    # Note that it inherits from `Decidim::ApplicationController, which
    # override its layout and provide all kinds of useful methods.
    class ApplicationController < Decidim::ApplicationController
      helper Decidim::ApplicationHelper
      include NeedsPermission

      register_permissions(Decidim::Courses::ApplicationController,
                           ::Decidim::Courses::Permissions,
                           ::Decidim::Admin::Permissions,
                           ::Decidim::Permissions)

      private

      def permissions_context
        super.merge(
          current_participatory_space: try(:current_participatory_space)
        )
      end

      def permission_class_chain
        ::Decidim.permissions_registry.chain_for(::Decidim::Courses::ApplicationController)
      end

      def permission_scope
        :public
      end
    end
  end
end
