# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This query filters resource_banks so only promoted ones are returned.
    class PromotedResourceBanks < Rectify::Query
      def query
        Decidim::ResourceBank.promoted
      end
    end
  end
end
