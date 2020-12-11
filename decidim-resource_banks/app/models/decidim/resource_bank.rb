# frozen_string_literal: true

module Decidim
  # The data store for a ResourceBank in the Decidim::ResourceBank space.
  class ResourceBank < ApplicationRecord
    include Decidim::Participable
    include Decidim::Publicable
    include Decidim::HasCategory
    include Decidim::HasAttachments
    include Decidim::HasAttachmentCollections
    include Decidim::ParticipatorySpaceResourceable
    include Decidim::HasUploadValidations
    include Decidim::Followable
    include Decidim::Traceable
    include Decidim::Loggable
    include Decidim::Randomable
    include Decidim::Searchable

    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization"

    belongs_to :area,
               foreign_key: "decidim_area_id",
               class_name: "Decidim::Area",
               optional: true

    validates_upload :hero_image
    mount_uploader :hero_image, Decidim::HeroImageUploader

    validates_upload :banner_image
    mount_uploader :banner_image, Decidim::BannerImageUploader

    alias_attribute :description, :text

    scope :order_by_most_recent, -> { order(created_at: :desc) }

    validates :slug, uniqueness: { scope: :organization }
    validates :slug, presence: true, format: { with: Decidim::ResourceBank.slug_format }

    searchable_fields({
                        participatory_space: :itself,
                        A: :title,
                        B: :description,
                        datetime: :published_at
                      },
                      index_on_create: ->(_bank) { false },
                      index_on_update: ->(bank) { bank.visible? })

    def to_param
      slug
    end

    # Allow ransacker to search for a key in a hstore column (`title`.`en`)
    ransacker :title do |parent|
      Arel::Nodes::InfixOperation.new("->>", parent.table[:title], Arel::Nodes.build_quoted(I18n.locale.to_s))
    end

    # Scope to return only the promoted resource banks.
    #
    # Returns an ActiveRecord::Relation.
    def self.promoted
      where(promoted: true)
    end

    def attachment_context
      :admin
    end
  end
end
