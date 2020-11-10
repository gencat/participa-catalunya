# frozen_string_literal: true

module Decidim
  module Courses
    # This query filters published courses only.
    class PublishedCourses < Rectify::Query
      def query
        Decidim::Course.published
      end
    end
  end
end
