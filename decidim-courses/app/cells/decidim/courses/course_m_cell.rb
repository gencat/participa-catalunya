# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the Medium (:m) course card
    # for an given instance of an Course
    class CourseMCell < Decidim::CardMCell
      include Decidim::ViewHooksHelper
      include ActionView::Helpers::DateHelper

      delegate :duration, to: :model

      private

      def description; end

      def statuses
        []
      end

      def modality
        t(model.modality, scope: "decidim.courses.modality") if model.modality
      end

      def spans_multiple_dates?
        start_date != end_date
      end

      def course_date
        return render(:multiple_dates) if spans_multiple_dates?

        render(:single_date)
      end

      def start_date
        model.start_date.to_date
      end

      def end_date
        model.end_date.to_date
      end

      def resource_path
        Decidim::Courses::Engine.routes.url_helpers.course_path(model)
      end
    end
  end
end
