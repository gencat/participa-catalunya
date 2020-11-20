# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This query class filters published resource_banks given an organization.
    class OrganizationPublishedResourceBanks < Rectify::Query
      def initialize(organization, user = nil)
        @organization = organization
        @user = user
      end

      def query
        Rectify::Query.merge(
          OrganizationResourceBanks.new(@organization),
          PublishedResourceBanks.new
        ).query
      end
    end
  end
end
