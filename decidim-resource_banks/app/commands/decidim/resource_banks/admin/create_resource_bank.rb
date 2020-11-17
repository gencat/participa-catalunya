# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A command with all the business logic when creating a new
      # resource_bank in the system.
      class CreateResourceBank < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
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

          if resource_bank.persisted?
            broadcast(:ok, resource_bank)
          else
            form.errors.add(:banner_image, resource_bank.errors[:banner_image]) if resource_bank.errors.include? :banner_image
            form.errors.add(:hero_image, resource_bank.errors[:hero_image]) if resource_bank.errors.include? :hero_image
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form

        def resource_bank
          @resource_bank ||= Decidim.traceability.create(
            ResourceBank,
            form.current_user,
            organization: form.current_organization,
            text: form.text,
            title: form.title,
            hashtag: form.hashtag,
            promoted: form.promoted,
            show_statistics: form.show_statistics,
            slug: form.slug,
            video_url: form.video_url,
            authorship: form.authorship,
            banner_image: form.banner_image,
            hero_image: form.hero_image
          )
        end
      end
    end
  end
end
