# frozen_string_literal: true

module Decidim
  module Courses
    # Helpers related to the Courses layout.
    module CoursesHelper
      include Decidim::ResourceHelper
      include Decidim::AttachmentsHelper
      include Decidim::CheckBoxesTreeHelper
      include Decidim::IconHelper
      include Decidim::SanitizeHelper
      include Decidim::ResourceReferenceHelper
      include Decidim::FiltersHelper

      def filter_modalities_values
        modalities_values = Decidim::Course::MODALITIES.map do |modality|
          TreeNode.new(
            TreePoint.new(modality, I18n.t("modality.#{modality}", scope: "decidim.courses"))
          )
        end

        TreeNode.new(
          TreePoint.new("", t("decidim.courses.courses_helper.filter_modalities_values.all")),
          modalities_values
        )
      end

      def filter_scopes_values
        main_scopes = current_organization.scopes.top_level

        scopes_values = main_scopes.includes(:scope_type, :children).flat_map do |scope|
          TreeNode.new(
            TreePoint.new(scope.id.to_s, translated_attribute(scope.name, current_organization)),
            scope_children_to_tree(scope)
          )
        end

        TreeNode.new(
          TreePoint.new("", t("decidim.courses.courses_helper.filter_scope_values.all")),
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
