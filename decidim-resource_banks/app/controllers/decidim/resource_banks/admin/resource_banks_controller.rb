# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # Controller that allows managing resource_banks.
      class ResourceBanksController < Decidim::ResourceBanks::Admin::ApplicationController
        include Decidim::ResourceBanks::Admin::Filterable
        helper_method :current_resource_bank, :current_participatory_space
        layout "decidim/admin/resource_banks"

        def index
          enforce_permission_to :read, :resource_bank_list
          @resource_banks = filtered_collection
        end

        def new
          enforce_permission_to :create, :resource_bank
          @form = form(ResourceBankForm).instance
        end

        def create
          enforce_permission_to :create, :resource_bank
          @form = form(ResourceBankForm).from_params(params)

          CreateResourceBank.call(@form) do
            on(:ok) do |_resource_bank|
              flash[:notice] = I18n.t("resource_banks.create.success", scope: "decidim.admin")
              redirect_to resource_banks_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("resource_banks.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :update, :resource_bank, resource_bank: current_resource_bank
          @form = form(ResourceBankForm).from_model(current_resource_bank)
          render layout: "decidim/admin/resource_bank"
        end

        def update
          enforce_permission_to :update, :resource_bank, resource_bank: current_resource_bank
          @form = form(ResourceBankForm).from_params(
            resource_bank_params,
            resource_bank_id: current_resource_bank.id
          )

          UpdateResourceBank.call(current_resource_bank, @form) do
            on(:ok) do |resource_bank|
              flash[:notice] = I18n.t("resource_banks.update.success", scope: "decidim.admin")
              redirect_to edit_resource_bank_path(resource_bank)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("resource_banks.update.error", scope: "decidim.admin")
              render :edit, layout: "decidim/admin/resource_bank"
            end
          end
        end

        private

        def collection
          @collection ||= OrganizationResourceBanks.new(current_user.organization).query
        end

        def current_resource_bank
          @current_resource_bank ||= collection.where(slug: params[:slug]).or(
            collection.where(id: params[:slug])
          ).first
        end

        alias current_participatory_space current_resource_bank

        def resource_bank_params
          {
            id: params[:slug],
            banner_image: current_resource_bank.banner_image,
            hero_image: current_resource_bank.hero_image
          }.merge(params[:resource_bank].to_unsafe_h)
        end
      end
    end
  end
end
