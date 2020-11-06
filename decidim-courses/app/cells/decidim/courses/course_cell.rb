# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the course card for an instance of an Course
    # the default size is the Medium Card (:m)
    class CourseCell < Decidim::ViewModel
      def show
        cell card_size, model, options
      end

      private

      def card_size
        "decidim/courses/course_m"
      end
    end
  end
end
