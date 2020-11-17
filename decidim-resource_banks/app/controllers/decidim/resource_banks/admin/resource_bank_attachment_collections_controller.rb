# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # Controller that allows managing all the attachment collections for a resource_bank.
      #
      class ResourceBankAttachmentCollectionsController < Decidim::ResourceBanks::Admin::ApplicationController
        include Concerns::ResourceBankAdmin
        include Decidim::Admin::Concerns::HasAttachmentCollections

        def after_destroy_path
          resource_bank_attachment_collections_path(current_resource_bank)
        end

        def collection_for
          current_resource_bank
        end
      end
    end
  end
end
