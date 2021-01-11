# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the Medium (:m) course card
    # for an given instance of an Course
    class CourseMCell < Decidim::CardMCell
      include Decidim::ViewHooksHelper
      include ActionView::Helpers::DateHelper

      delegate :duration, :schedule, to: :model

      private

      def description
      end

      def statuses
        []
      end

      def modality
        t(model.modality, scope: "decidim.courses.modality") if model.modality
      end

      def resource_path
        Decidim::Courses::Engine.routes.url_helpers.course_path(model)
      end
    end
  end
end
