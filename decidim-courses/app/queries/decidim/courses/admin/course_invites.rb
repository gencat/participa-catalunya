# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A class used to find the CourseInvites by their status status.
      class CourseInvites < Rectify::Query
        # Syntactic sugar to initialize the class and return the queried objects.
        #
        # course_invites - the initial Invites relation that needs to be filtered.
        # query - query to filter course_invites
        # status - invite status to be used as a filter
        def self.for(course_invites, query = nil, status = nil)
          new(course_invites, query, status).query
        end

        # Initializes the class.
        #
        # course_invites - the initial Invites relation that need to be filtered
        # query - query to filter course_invites
        # status - invite status to be used as a filter
        def initialize(course_invites, query = nil, status = nil)
          @course_invites = course_invites
          @query = query
          @status = status
        end

        # List the course_invites by the different filters.
        def query
          @course_invites = filter_by_search(@course_invites)
          @course_invites = filter_by_status(@course_invites)
          @course_invites
        end

        private

        def filter_by_search(course_invites)
          return course_invites if @query.blank?

          course_invites.joins(:user).where(
            User.arel_table[:name].lower.matches("%#{@query}%").or(User.arel_table[:email].lower.matches("%#{@query}%"))
          )
        end

        def filter_by_status(course_invites)
          case @status
          when "accepted"
            course_invites.where.not(accepted_at: nil)
          when "rejected"
            course_invites.where.not(rejected_at: nil)
          when "sent"
            course_invites.where.not(sent_at: nil).where(accepted_at: nil, rejected_at: nil)
          else
            course_invites
          end
        end
      end
    end
  end
end
