# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This query class filters all resource_banks given an organization.
    class OrganizationResourceBanks < Rectify::Query
      def initialize(organization)
        @organization = organization
      end

      def query
        Decidim::ResourceBank.where(organization: @organization)
      end
    end
  end
end
