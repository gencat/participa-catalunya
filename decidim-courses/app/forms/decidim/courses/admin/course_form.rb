# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A form object used to create courses from the admin
      # dashboard.
      #
      class CourseForm < Form
        include TranslatableAttributes
        include Decidim::HasUploadValidations

        mimic :course

        translatable_attribute :announcement, String
        translatable_attribute :description, String
        translatable_attribute :instructors, String
        translatable_attribute :title, String
        translatable_attribute :objectives, String
        translatable_attribute :addressed_to, String
        translatable_attribute :programme, String
        translatable_attribute :professorship, String
        translatable_attribute :methodology, String
        translatable_attribute :seats, String

        attribute :hashtag, String
        attribute :promoted, Boolean
        attribute :area_id, Integer
        attribute :scope_id, Integer
        attribute :scopes_enabled, Boolean
        attribute :show_statistics, Boolean
        attribute :slug, String

        attribute :address, String
        attribute :start_date, Decidim::Attributes::TimeWithZone
        attribute :end_date, Decidim::Attributes::TimeWithZone
        attribute :schedule, String
        attribute :duration, String
        attribute :modality, String
        attribute :registration_link, String

        attribute :banner_image
        attribute :hero_image
        attribute :remove_banner_image
        attribute :remove_hero_image

        validates :area, presence: true, if: proc { |object| object.area_id.present? }
        validates :scope, presence: true, if: proc { |object| object.scope_id.present? }
        validates :slug, presence: true, format: { with: Decidim::Course.slug_format }

        validate :slug_uniqueness

        validates :modality, presence: true, inclusion: { in: ::Decidim::Course::MODALITIES }
        validates :title, :description, translatable_presence: true

        validates :banner_image, passthru: { to: Decidim::Course }
        validates :hero_image, passthru: { to: Decidim::Course }

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
