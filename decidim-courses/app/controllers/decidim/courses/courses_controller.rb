# frozen_string_literal: true

module Decidim
  module Courses
    # A controller that holds the logic to show Courses in a public layout.
    class CoursesController < Decidim::Courses::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: :show

      include FilterResource
      include Paginable

      helper_method :stats, :courses, :promoted_courses

      def index
        enforce_permission_to :list, :course

        return unless search.results.blank? && params.dig("filter", "date") != "past"

        @past_courses = search_klass.new(search_params.merge(date: "past"))

        if @past_courses.results.present?
          params[:filter] ||= {}
          params[:filter][:date] = "past"
          @forced_past_courses = true
          @search = @past_courses
        end
      end

      def show
        enforce_permission_to :read, :course, course: current_participatory_space
      end

      private

      def courses
        @courses = search.results.order(promoted: :desc)
        @courses = paginate(@courses)
      end

      alias collection courses

      def search_klass
        CourseSearch
      end

      def default_filter_params
        {
          date: "upcoming",
          search_text: "",
          modality: default_filter_modality_params,
          scope_id: default_filter_scope_params
        }
      end

      def default_filter_modality_params
        %w(all) + Decidim::Course::MODALITIES
      end

      def default_filter_scope_params
        %w(all global) + current_organization.scopes.pluck(:id).map(&:to_s)
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
