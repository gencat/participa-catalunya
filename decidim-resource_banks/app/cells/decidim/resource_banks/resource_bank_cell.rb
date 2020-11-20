# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This cell renders the resource_bank card for an instance of an ResourceBank
    # the default size is the Medium Card (:m)
    class ResourceBankCell < Decidim::ViewModel
      def show
        cell card_size, model, options
      end

      private

      def card_size
        "decidim/resource_banks/resource_bank_m"
      end
    end
  end
end
