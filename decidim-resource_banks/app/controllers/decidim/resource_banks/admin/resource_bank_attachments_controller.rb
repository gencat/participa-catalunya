# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # Controller that allows managing all the attachments for a resource_bank.
      #
      class ResourceBankAttachmentsController < Decidim::ResourceBanks::Admin::ApplicationController
        include Concerns::ResourceBankAdmin
        include Decidim::Admin::Concerns::HasAttachments

        def after_destroy_path
          resource_bank_attachments_path(current_resource_bank)
        end

        def attached_to
          current_resource_bank
        end
      end
    end
  end
end
