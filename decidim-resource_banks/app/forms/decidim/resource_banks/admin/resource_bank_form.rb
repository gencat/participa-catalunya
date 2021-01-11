# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A form object used to create resource_banks from the admin
      # dashboard.
      #
      class ResourceBankForm < Form
        include TranslatableAttributes
        include Decidim::HasUploadValidations

        mimic :resource_bank

        translatable_attribute :announcement, String
        translatable_attribute :text, String
        translatable_attribute :title, String

        attribute :hashtag, String
        attribute :promoted, Boolean
        attribute :area_id, Integer
        attribute :scope_id, Integer
        attribute :scopes_enabled, Boolean
        attribute :show_statistics, Boolean
        attribute :slug, String

        attribute :authorship, String
        attribute :video_url, String

        attribute :banner_image
        attribute :hero_image
        attribute :remove_banner_image
        attribute :remove_hero_image

        validates :area, presence: true, if: proc { |object| object.area_id.present? }
        validates :scope, presence: true, if: proc { |object| object.scope_id.present? }
        validates :slug, presence: true, format: { with: Decidim::ResourceBank.slug_format }

        validate :slug_uniqueness
        validate :video_url_format

        validates :title, :text, translatable_presence: true

        validates :banner_image, passthru: { to: Decidim::ResourceBank }
        validates :hero_image, passthru: { to: Decidim::ResourceBank }

        alias organization current_organization

        def map_model(model)
          self.area_id = model.decidim_area_id
          self.scope_id = model.decidim_scope_id
        end

        def area
          @area ||= current_organization.areas.find_by(id: area_id)
        end

        def scope
          @scope ||= current_organization.scopes.find_by(id: scope_id)
        end

        def video_url
          return if super.blank?

          return "http://#{super}" unless super.match?(%r{\A(http|https)://}i)

          super
        end

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

        def video_url_format
          return if video_url.blank?

          uri = URI.parse(video_url)
          errors.add :video_url, :invalid if !uri.is_a?(URI::HTTP) || uri.host.nil?
        rescue URI::InvalidURIError
          errors.add :video_url, :invalid
        end
      end
    end
  end
end
