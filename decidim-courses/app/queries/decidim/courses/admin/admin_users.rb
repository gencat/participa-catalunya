# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A class used to find the admins for an course.
      class AdminUsers < Rectify::Query
        # Syntactic sugar to initialize the class and return the queried objects.
        #
        # course - an course that needs to find its course admins
        def self.for(course)
          new(course).query
        end

        # Initializes the class.
        #
        # course - an course that needs to find its course admins
        def initialize(course)
          @course = course
        end

        # Finds organization admins and the users with role admin for the given course.
        #
        # Returns an ActiveRecord::Relation.
        def query
          Decidim::User.where(id: organization_admins).or(course_user_admins)
        end

        private

        attr_reader :course

        def organization_admins
          course.organization.admins
        end

        def course_user_admins
          course_user_admin_ids = Decidim::CourseUserRole
                                  .where(course: course, role: :admin)
                                  .pluck(:decidim_user_id)
          Decidim::User.where(id: course_user_admin_ids)
        end
      end
    end
  end
end
