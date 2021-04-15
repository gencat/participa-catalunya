# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A command that sets the settings for resource banks module.
      class UpdateResourceBanksSettings < Rectify::Command
        # Public: Initializes the command.
        #
        # resource_settings - A resource_setting object to update.
        # form - A form object with the params.
        def initialize(resource_settings, form)
          @resource_settings = resource_settings
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form or resource_settings isn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid? || resource_settings.invalid?

          update_resource_setting!

          broadcast(:ok)
        end

        private

        attr_reader :form, :resource_settings

        def update_resource_setting!
          Decidim.traceability.update!(
            @resource_settings,
            form.current_user,
            decidim_scope_id: form.decidim_scope_id
          )
        end
      end
    end
  end
end
