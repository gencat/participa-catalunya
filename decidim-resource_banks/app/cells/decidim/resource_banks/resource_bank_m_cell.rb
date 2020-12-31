# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This cell renders the Medium (:m) resource_bank card
    # for an given instance of an ResourceBank
    class ResourceBankMCell < Decidim::CardMCell
      include Decidim::ViewHooksHelper
      include ActionView::Helpers::DateHelper

      # Needed for the view hooks
      def current_participatory_space
        model
      end

      private

      def has_image? # rubocop:disable Naming/PredicateName
        true
      end

      def resource_path
        Decidim::ResourceBanks::Engine.routes.url_helpers.resource_bank_path(model)
      end

      def resource_image_path
        model.hero_image.url
      end

      def statuses
        [:authorship]
      end

      def authorship_status
        model.authorship
      end

      def resource_icon
        icon "resource_banks", class: "icon--big"
      end
    end
  end
end
