# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the Medium (:m) course card
    # for an given instance of an Course
    class CourseMCell < Decidim::CardMCell
      include Decidim::ViewHooksHelper
      include ActionView::Helpers::DateHelper

      private

      def has_image? # rubocop:disable Naming/PredicateName
        true
      end

      def resource_path
        Decidim::Courses::Engine.routes.url_helpers.course_path(model)
      end

      def resource_image_path
        model.hero_image.url
      end

      def statuses
        [:start_date, :duration, :modality]
      end

      def start_date_status
        l(model.start_date, format: :decidim_short) if model.start_date
      end

      def duration_status
        model.duration if model.duration
      end

      def modality_status
        t(model.modality, scope: "decidim.courses.modality") if model.modality
      end

      def resource_icon
        icon "courses", class: "icon--big"
      end
    end
  end
end
