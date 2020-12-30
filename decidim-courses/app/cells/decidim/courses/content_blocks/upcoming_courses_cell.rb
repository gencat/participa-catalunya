# frozen_string_literal: true

module Decidim
  module Courses
    module ContentBlocks
      class UpcomingCoursesCell < Decidim::ViewModel
        include Decidim::CardHelper

        def show
          return if upcoming_courses.blank?

          render
        end

        def upcoming_courses
          @upcoming_courses ||= Decidim::Course
                                .where(organization: current_organization)
                                .upcoming
                                .order(course_date: :asc)
                                .limit(limit)
        end

        def courses_path
          Decidim::Courses::Engine.routes.url_helpers.courses_path
        end

        private

        def limit
          8
        end
      end
    end
  end
end
