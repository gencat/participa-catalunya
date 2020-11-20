# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This query filters published resource_banks only.
    class PublishedResourceBanks < Rectify::Query
      def query
        Decidim::ResourceBank.published
      end
    end
  end
end
