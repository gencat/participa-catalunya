# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A command with all the business logic
      # to update a resource_bank in the system.
      class UpdateResourceBank < Rectify::Command
        # Public: Initializes the command.
        #
        # resource_bank - the Resource bank to update
        # form - A form object with the params.
        def initialize(resource_bank, form)
          @resource_bank = resource_bank
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          update_resource_bank

          if @resource_bank.valid?
            broadcast(:ok, @resource_bank)
          else
            form.errors.add(:hero_image, @resource_bank.errors[:hero_image]) if @resource_bank.errors.include? :hero_image
            form.errors.add(:banner_image, @resource_bank.errors[:banner_image]) if @resource_bank.errors.include? :banner_image
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form, :resource_bank

        def update_resource_bank
          @resource_bank.assign_attributes(attributes)
          save_resource_bank if @resource_bank.valid?
        end

        def save_resource_bank
          transaction do
            @resource_bank.save!
            Decidim.traceability.perform_action!(:update, @resource_bank, form.current_user) do
              @resource_bank
            end
          end
        end

        def attributes
          {
            text: form.text,
            title: form.title,
            hashtag: form.hashtag,
            promoted: form.promoted,
            area: form.area,
            scope: form.scope,
            scopes_enabled: form.scopes_enabled,
            show_statistics: form.show_statistics,
            slug: form.slug,
            video_url: form.video_url,
            authorship: form.authorship,
            hero_image: form.hero_image,
            remove_hero_image: form.remove_hero_image,
            banner_image: form.banner_image,
            remove_banner_image: form.remove_banner_image
          }
        end
      end
    end
  end
end
