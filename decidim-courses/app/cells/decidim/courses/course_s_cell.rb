# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the Small (:s) course card
    # for an given instance of a Course
    class CourseSCell < CourseMCell
      def instructors
        translated_attribute model.instructors
      end
    end
  end
end
