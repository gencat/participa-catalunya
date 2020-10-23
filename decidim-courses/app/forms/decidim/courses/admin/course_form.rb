# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A form object used to create courses from the admin
      # dashboard.
      #
      class CourseForm < Form
        include TranslatableAttributes

        mimic :course

        translatable_attribute :description, String
        translatable_attribute :instructors, String
        translatable_attribute :title, String

        attribute :hashtag, String
        attribute :promoted, Boolean
        attribute :scope_id, Integer
        attribute :scopes_enabled, Boolean
        attribute :show_statistics, Boolean
        attribute :slug, String

        attribute :address, String
        attribute :course_date, Decidim::Attributes::LocalizedDate
        attribute :duration, Integer
        attribute :modality, String
        attribute :registration_link, String

        attribute :banner_image
        attribute :hero_image
        attribute :remove_banner_image
        attribute :remove_hero_image

        validates :scope, presence: true, if: proc { |object| object.scope_id.present? }
        validates :slug, presence: true, format: { with: Decidim::Course.slug_format }

        validate :slug_uniqueness

        validates :modality, inclusion: { in: ::Decidim::Course::MODALITIES }
        validates :title, :description, translatable_presence: true

        validates :banner_image,
                  file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                  file_content_type: { allow: ["image/jpeg", "image/png"] }
        validates :hero_image,
                  file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                  file_content_type: { allow: ["image/jpeg", "image/png"] }

        alias organization current_organization

        def map_model(model)
          self.scope_id = model.decidim_scope_id
        end

        def scope
          @scope ||= current_organization.scopes.find_by(id: scope_id)
        end

        def modalities_for_select
          ::Decidim::Course::MODALITIES.map do |modality|
            [
              I18n.t("modality.#{modality}", scope: "decidim.courses"),
              modality
            ]
          end
        end

        private

        def organization_courses
          OrganizationCourses.new(current_organization).query
        end

        def slug_uniqueness
          return unless organization_courses
                        .where(slug: slug)
                        .where.not(id: context[:course_id])
                        .any?

          errors.add(:slug, :taken)
        end
      end
    end
  end
end
