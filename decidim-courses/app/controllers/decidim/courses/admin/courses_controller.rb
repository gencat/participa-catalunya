# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # Controller that allows managing courses.
      class CoursesController < Decidim::Courses::Admin::ApplicationController
        include Decidim::Courses::Admin::Filterable
        helper_method :current_course, :current_participatory_space
        layout "decidim/admin/courses"

        def index
          enforce_permission_to :read, :course_list
          @courses = filtered_collection
        end

        private

        def collection
          @collection ||= OrganizationCourses.new(current_user.organization).query
        end

        def current_course
          @current_course ||= collection.where(slug: params[:slug]).or(
            collection.where(id: params[:slug])
          ).first
        end

        alias current_participatory_space current_course
      end
    end
  end
end
