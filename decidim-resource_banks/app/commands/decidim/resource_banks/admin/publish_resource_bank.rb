# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A command that sets a resource_bank as published.
      class PublishResourceBank < Rectify::Command
        # Public: Initializes the command.
        #
        # resource_bank - A ResourceBank that will be published
        # current_user - the user performing the action
        def initialize(resource_bank, current_user)
          @resource_bank = resource_bank
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the data wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if resource_bank.nil? || resource_bank.published?

          Decidim.traceability.perform_action!("publish", resource_bank, current_user, visibility: "all") do
            resource_bank.publish!
          end

          broadcast(:ok)
        end

        private

        attr_reader :resource_bank, :current_user
      end
    end
  end
end
