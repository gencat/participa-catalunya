# frozen_string_literal: true

module Decidim
  module Courses
    # This class serializes an Course so it can be exported to CSV, JSON or other formats.
    class CourseSerializer < Decidim::Exporters::Serializer
      include Decidim::ApplicationHelper
      include Decidim::ResourceHelper
      include Decidim::TranslationsHelper

      # Public: Initializes the serializer with a course.
      def initialize(course)
        @course = course
      end

      # Public: Exports a hash with the serialized data for this course.
      def serialize
        {
          id: course.id,
          slug: course.slug,
          hashtag: course.hashtag,
          decidim_organization_id: course.decidim_organization_id,
          title: course.title,
          description: course.description,
          remote_hero_image_url: Decidim::Courses::CoursePresenter.new(course).hero_image_url,
          remote_banner_image_url: Decidim::Courses::CoursePresenter.new(course).banner_image_url,
          decidim_scope_id: course.decidim_scope_id,
          show_statistics: course.show_statistics,
          scopes_enabled: course.scopes_enabled,
          modality: course.modality,
          instructors: course.instructors,
          registration_link: course.registration_link,
          address: course.address,
          schedule: course.schedule,
          start_date: course.start_date,
          end_date: course.end_date,
          duration: course.duration,
          created_at: course.created_at,
          area: {
            id: course.area.try(:id),
            name: course.area.try(:name) || empty_translatable
          },
          scope: {
            id: course.scope.try(:id),
            name: course.scope.try(:name) || empty_translatable
          },
          attachments: {
            attachment_collections: serialize_attachment_collections,
            files: serialize_attachments
          }
        }
      end

      private

      attr_reader :course

      def serialize_attachment_collections
        return unless course.attachment_collections.any?

        course.attachment_collections.map do |collection|
          {
            id: collection.try(:id),
            name: collection.try(:name),
            weight: collection.try(:weight),
            description: collection.try(:description)
          }
        end
      end

      def serialize_attachments
        return unless course.attachments.any?

        course.attachments.map do |attachment|
          {
            id: attachment.try(:id),
            title: attachment.try(:title),
            weight: attachment.try(:weight),
            description: attachment.try(:description),
            attachment_collection: {
              name: attachment.attachment_collection.try(:name),
              weight: attachment.attachment_collection.try(:weight),
              description: attachment.attachment_collection.try(:description)
            },
            remote_file_url: Decidim::AttachmentPresenter.new(attachment).attachment_file_url
          }
        end
      end
    end
  end
end
