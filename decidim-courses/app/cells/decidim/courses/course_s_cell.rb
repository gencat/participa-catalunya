# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the Small (:s) course card
    # for an given instance of a Course
    class CourseSCell < CourseMCell
      def title
        translated_attribute model.title
      end

      def instructors
        translated_attribute model.instructors
      end

      def start_date
        l(model.start_date, format: :decidim_short) if model.start_date
      end

      def modality
        t(model.modality, scope: "decidim.courses.modality") if model.modality
      end
    end
  end
end
