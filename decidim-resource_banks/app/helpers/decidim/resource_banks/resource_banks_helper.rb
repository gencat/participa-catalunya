# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # Helpers related to the ResourceBanks layout.
    module ResourceBanksHelper
      include Decidim::ResourceHelper
      include Decidim::AttachmentsHelper
      include Decidim::CheckBoxesTreeHelper
      include Decidim::IconHelper
      include Decidim::SanitizeHelper
      include Decidim::ResourceReferenceHelper
      include Decidim::FiltersHelper

      def filter_scopes_values
        main_scopes = current_organization.scopes.top_level

        scopes_values = main_scopes.includes(:scope_type, :children).flat_map do |scope|
          TreeNode.new(
            TreePoint.new(scope.id.to_s, translated_attribute(scope.name, current_organization)),
            scope_children_to_tree(scope)
          )
        end

        TreeNode.new(
          TreePoint.new("", t("decidim.resource_banks.resource_banks_helper.filter_scope_values.all")),
          scopes_values
        )
      end

      def scope_children_to_tree(scope)
        return unless scope.children.any?

        scope.children.includes(:scope_type, :children).flat_map do |child|
          TreeNode.new(
            TreePoint.new(child.id.to_s, translated_attribute(child.name, current_organization)),
            scope_children_to_tree(child)
          )
        end
      end
    end
  end
end
