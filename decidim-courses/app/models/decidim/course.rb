# frozen_string_literal: true

module Decidim
  # The data store for a Course in the Decidim::Course space.
  class Course < ApplicationRecord
    include Decidim::Participable
    include Decidim::Publicable
    include Decidim::HasCategory      
    include Decidim::HasAttachments
    include Decidim::Resourceable
    include Decidim::Traceable
    include Decidim::Loggable
    include Decidim::ParticipatorySpaceResourceable
    include Decidim::Randomable
    include Decidim::Searchable


    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization"

    belongs_to :highlighted_scope,
               foreign_key: "decidim_highlighted_scope_id",
               class_name: "Decidim::Scope"

    mount_uploader :banner_image, Decidim::BannerImageUploader
    mount_uploader :introductory_image, Decidim::BannerImageUploader

    scope :order_by_most_recent, -> { order(created_at: :desc) }

    def to_param
      slug
    end

    # Allow ransacker to search for a key in a hstore column (`title`.`en`)
    ransacker :title do |parent|
      Arel::Nodes::InfixOperation.new("->>", parent.table[:title], Arel::Nodes.build_quoted(I18n.locale.to_s))
    end
  end
end
