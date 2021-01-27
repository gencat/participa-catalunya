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
        case @options[:size]
        when :s
          "decidim/courses/course_s"
        else
          "decidim/courses/course_m"
        end
      end

      # Needed for the view hooks
      def current_participatory_space
        model
      end

      def resource_icon
        icon "courses", class: "icon--big"
      end
    end
  end
end
