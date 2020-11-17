# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A form object used to create resource_banks from the admin
      # dashboard.
      #
      class ResourceBankForm < Form
        include TranslatableAttributes

        mimic :resource_bank

        translatable_attribute :text, String
        translatable_attribute :title, String

        attribute :hashtag, String
        attribute :promoted, Boolean
        attribute :show_statistics, Boolean
        attribute :slug, String

        attribute :authorship, String
        attribute :video, String

        attribute :banner_image
        attribute :hero_image
        attribute :remove_banner_image
        attribute :remove_hero_image

        validates :slug, presence: true, format: { with: Decidim::ResourceBank.slug_format }

        validate :slug_uniqueness

        validates :title, :text, translatable_presence: true

        validates :banner_image,
                  file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                  file_content_type: { allow: ["image/jpeg", "image/png"] }
        validates :hero_image,
                  file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                  file_content_type: { allow: ["image/jpeg", "image/png"] }

        alias organization current_organization

        private

        def organization_resource_banks
          OrganizationResourceBanks.new(current_organization).query
        end

        def slug_uniqueness
          return unless organization_resource_banks
                        .where(slug: slug)
                        .where.not(id: context[:resource_bank_id])
                        .any?

          errors.add(:slug, :taken)
        end
      end
    end
  end
end
