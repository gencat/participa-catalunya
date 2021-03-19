# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the Small (:s) course card
    # for an given instance of a Course
    class CourseSCell < CourseMCell
      def title
        truncate(strip_tags(translated_attribute(model.description)), length: 40)
      end

      def description
        truncate(strip_tags(translated_attribute(model.description)), length: 80)
      end

      def organizer
        translated_attribute model.area&.name
      end

      def schedule
        model.schedule || ""
      end

      def course_date
        model.start_date.strftime("%d/%m/%Y")
      end

      def i18n_scope
          "decidim.courses.content_blocks.upcoming_courses"
      end
    end
  end
end
