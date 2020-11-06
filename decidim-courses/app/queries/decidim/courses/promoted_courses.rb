# frozen_string_literal: true

module Decidim
  module Courses
    # This query filters courses so only promoted ones are returned.
    class PromotedCourses < Rectify::Query
      def query
        Decidim::Course.promoted
      end
    end
  end
end
