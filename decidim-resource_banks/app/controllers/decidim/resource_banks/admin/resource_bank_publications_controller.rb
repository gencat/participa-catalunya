# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # Controller that allows managing resource_bank publications.
      #
      class ResourceBankPublicationsController < Decidim::ResourceBanks::Admin::ApplicationController
        include Concerns::ResourceBankAdmin

        def create
          enforce_permission_to :publish, :resource_bank, resource_bank: current_resource_bank

          PublishResourceBank.call(current_resource_bank, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("resource_bank_publications.create.success", scope: "decidim.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("resource_bank_publications.create.error", scope: "decidim.admin")
            end

            redirect_back(fallback_location: resource_banks_path)
          end
        end

        def destroy
          enforce_permission_to :publish, :resource_bank, resource_bank: current_resource_bank

          UnpublishResourceBank.call(current_resource_bank, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("resource_bank_publications.destroy.success", scope: "decidim.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("resource_bank_publications.destroy.error", scope: "decidim.admin")
            end

            redirect_back(fallback_location: resource_banks_path)
          end
        end
      end
    end
  end
end
