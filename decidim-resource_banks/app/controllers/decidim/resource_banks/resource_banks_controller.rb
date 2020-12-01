# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # A controller that holds the logic to show ResourceBanks in a public layout.
    class ResourceBanksController < Decidim::ResourceBanks::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: :show

      include FilterResource
      include Paginable

      helper_method :stats, :resource_banks, :promoted_resource_banks

      def index
        enforce_permission_to :list, :resource_bank
      end

      def show
        enforce_permission_to :read, :resource_bank, resource_bank: current_participatory_space
      end

      private

      def resource_banks
        @resource_banks = search.results.order(promoted: :desc)
        @resource_banks = paginate(@resource_banks)
      end

      alias collection resource_banks

      def default_filter_params
        {
          search_text: "",
        }
      end

      def search_klass
        ResourceBankSearch
      end

      def current_participatory_space
        return unless params[:slug]

        @current_participatory_space ||= OrganizationResourceBanks.new(current_organization).query.where(slug: params[:slug]).or(
          OrganizationResourceBanks.new(current_organization).query.where(id: params[:slug])
        ).first!
      end

      def published_resource_banks
        @published_resource_banks ||= OrganizationPublishedResourceBanks.new(current_organization, current_user)
      end

      def promoted_resource_banks
        @promoted_resource_banks ||= published_resource_banks | PromotedResourceBanks.new
      end

       # TODO create ResourceBankStatsPresenter
      def stats
        #@stats ||= ResourceBankStatsPresenter.new(resource_bank: current_participatory_space)
      end
    end
  end
end
