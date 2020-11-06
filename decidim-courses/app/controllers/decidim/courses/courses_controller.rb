# frozen_string_literal: true

module Decidim
  module Courses
    # A controller that holds the logic to show Courses in a public layout.
    class CoursesController < Decidim::Courses::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: :show
      include FilterResource

      helper_method :stats, :courses, :promoted_courses

      def index
        enforce_permission_to :list, :course

        respond_to do |format|
          format.html do
            raise ActionController::RoutingError, "Not Found" if published_courses.none?

            render "index"
          end

          format.js do
            raise ActionController::RoutingError, "Not Found" if published_courses.none?

            render "index"
          end
        end
      end

      def show
        enforce_permission_to :read, :course, course: current_participatory_space
      end

      private

      def courses
        @courses ||= search.results.order(promoted: :desc)
      end

      alias collection courses

      def search_klass
        CourseSearch
      end

      def default_filter_params
        {
          scope_id: nil,
          modality: nil
        }
      end

      def current_participatory_space
        return unless params[:slug]

        @current_participatory_space ||= OrganizationCourses.new(current_organization).query.where(slug: params[:slug]).or(
          OrganizationCourses.new(current_organization).query.where(id: params[:slug])
        ).first!
      end

      def published_courses
        @published_courses ||= OrganizationPublishedCourses.new(current_organization, current_user)
      end

      def promoted_courses
        @promoted_courses ||= published_courses | PromotedCourses.new
      end

      # TODO: create CourseStatsPresenter
      def stats
        # @stats ||= CourseStatsPresenter.new(course: current_participatory_space)
      end
    end
  end
end
