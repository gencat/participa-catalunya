# frozen_string_literal: true

module Decidim
  # The data store for a Course in the Decidim::Course space.
  class Course < ApplicationRecord
    include Decidim::Participable
    include Decidim::Publicable
    include Decidim::HasCategory
    include Decidim::Scopable
    include Decidim::HasAttachments
    include Decidim::Followable
    include Decidim::HasAttachmentCollections
    include Decidim::Resourceable
    include Decidim::Traceable
    include Decidim::Loggable
    include Decidim::Randomable
    include Decidim::Searchable

    MODALITIES = %w(face-to-face online blended).freeze

    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization"

    mount_uploader :hero_image, Decidim::HeroImageUploader
    mount_uploader :banner_image, Decidim::BannerImageUploader

    scope :order_by_most_recent, -> { order(created_at: :desc) }

    validates :slug, uniqueness: { scope: :organization }
    validates :slug, presence: true, format: { with: Decidim::Course.slug_format }

    searchable_fields({
                        scope_id: :decidim_scope_id,
                        participatory_space: :itself,
                        A: :title,
                        B: :description,
                        datetime: :published_at
                      },
                      index_on_create: ->(_course) { false },
                      index_on_create: ->(course) { course.visible? },
                      index_on_update: ->(course) { course.visible? })

    def to_param
      slug
    end

    # Allow ransacker to search for a key in a hstore column (`title`.`en`)
    ransacker :title do |parent|
      Arel::Nodes::InfixOperation.new("->>", parent.table[:title], Arel::Nodes.build_quoted(I18n.locale.to_s))
    end
  end
end
