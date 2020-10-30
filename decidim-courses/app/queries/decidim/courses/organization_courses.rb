# frozen_string_literal: true

module Decidim
  module Courses
    # This query class filters all courses given an organization.
    class OrganizationCourses < Rectify::Query
      def initialize(organization)
        @organization = organization
      end

      def query
        Decidim::Course.where(organization: @organization)
      end
    end
  end
end
