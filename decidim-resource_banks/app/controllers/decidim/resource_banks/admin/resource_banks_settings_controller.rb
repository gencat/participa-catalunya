# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # Controller that allows setting the root scope to be used.
      #
      class ResourceBanksSettingsController < Decidim::ResourceBanks::Admin::ApplicationController
        layout "decidim/admin/resource_banks"

        # GET /admin/resources_settings/edit
        def edit
          enforce_permission_to :edit, :resources_settings, resources_settings: current_resources_settings
          @form = resources_settings_form.from_model(current_resources_settings)
        end

        # PUT /admin/resources_settings/:id
        def update
          enforce_permission_to :update, :resources_settings, resources_settings: current_resources_settings

          @form = resources_settings_form
                  .from_params(params, resources_settings: current_resources_settings)

          UpdateResourceBanksSettings.call(current_resources_settings, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("resources_settings.update.success", scope: "decidim.admin")
              redirect_to edit_settings_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("resources_settings.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        private

        def current_resources_settings
          @current_resources_settings ||= Decidim::ResourcesSetting.find_or_create_by!(decidim_organization_id: current_organization.id)
        end

        def resources_settings_form
          form(Decidim::ResourceBanks::Admin::ResourceBanksSettingForm)
        end
      end
    end
  end
end
