# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # A controller that holds the logic to show ResourceBanks in a public layout.
    class ResourceBanksController < Decidim::ResourceBanks::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: :show
      include FilterResource

      helper Decidim::ResourceHelper
      helper Decidim::AttachmentsHelper
      helper Decidim::ResourceReferenceHelper
      layout "decidim/resource_bank", only: :show

      helper_method :stats

      def show
        enforce_permission_to :read, :resource_bank, resource_bank: current_participatory_space
      end

      private

      def current_participatory_space
        return unless params[:slug]

        @current_participatory_space ||=  Decidim::ResourceBank.where(slug: params[:slug], organization: current_organization).first
      end

      def current_participatory_space_manifest
        @current_participatory_space_manifest ||= Decidim.find_participatory_space_manifest(:resource_banks)
      end

      # TODO create ResourceBankStatsPresenter
      def stats
        #@stats ||= ResourceBankStatsPresenter.new(resource_bank: current_participatory_space)
      end
    end
  end
end
