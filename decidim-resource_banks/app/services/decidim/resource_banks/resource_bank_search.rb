# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # Service that encapsulates all logic related to filtering resource_banks.
    class ResourceBankSearch < ParticipatorySpaceSearch
      def initialize(options = {})
        scope = options.fetch(:scope, ResourceBank.all)
        super(scope, options)
      end

      # We need to return the scope generated by the base_query method in the parent
      # class because it doesn't return it, only generates it. We need to do a PR on Decidim?
      def base_query
        super

        @scope
      end

      def current_locale
        I18n.locale.to_s
      end

      # Handle the search_text filter
      def search_search_text
        query
          .where(
            "title->>'#{current_locale}' ILIKE ?", "%#{search_text}%"
          )
          .or(
            query.where(
              "text->>'#{current_locale}' ILIKE ?", "%#{search_text}%"
            )
          )
          .or(
            query.where(
              "authorship ILIKE ?", "%#{search_text}%"
            )
          )
          .or(
            query.where(
              "cast(decidim_resource_banks.id as text) ILIKE ?", "%#{search_text}%"
            )
          )
      end
    end
  end
end
