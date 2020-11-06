# frozen_string_literal: true

module Decidim
  module Courses
    # This query class filters published courses given an organization.
    class OrganizationPublishedCourses < Rectify::Query
      def initialize(organization, user = nil)
        @organization = organization
        @user = user
      end

      def query
        Rectify::Query.merge(
          OrganizationCourses.new(@organization),
          PublishedCourses.new
        ).query
      end
    end
  end
end
