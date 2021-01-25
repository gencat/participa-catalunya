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

        def new
          enforce_permission_to :create, :course
          @form = form(CourseForm).instance
        end

        def create
          enforce_permission_to :create, :course
          @form = form(CourseForm).from_params(params)

          CreateCourse.call(@form) do
            on(:ok) do |_course|
              flash[:notice] = I18n.t("courses.create.success", scope: "decidim.admin")
              redirect_to courses_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("courses.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :update, :course, course: current_course
          @form = form(CourseForm).from_model(current_course)
          render layout: "decidim/admin/course"
        end

        def update
          enforce_permission_to :update, :course, course: current_course
          @form = form(CourseForm).from_params(
            course_params,
            course_id: current_course.id
          )

          UpdateCourse.call(current_course, @form) do
            on(:ok) do |course|
              flash[:notice] = I18n.t("courses.update.success", scope: "decidim.admin")
              redirect_to edit_course_path(course)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("courses.update.error", scope: "decidim.admin")
              render :edit, layout: "decidim/admin/course"
            end
          end
        end

        # GET /admin/courses/export
        def export
          enforce_permission_to :export, :courses

          Decidim::Courses::ExportCoursesJob.perform_later(current_user, params[:format] || default_format)

          flash[:notice] = t("decidim.admin.exports.notice")

          redirect_back(fallback_location: courses_path)
        end

        private

        def default_format
          "json"
        end

        def collection
          @collection ||= OrganizationCourses.new(current_user.organization).query
        end

        def current_course
          @current_course ||= collection.where(slug: params[:slug]).or(
            collection.where(id: params[:slug])
          ).first
        end

        alias current_participatory_space current_course

        def course_params
          {
            id: params[:slug],
            banner_image: current_course.banner_image,
            hero_image: current_course.hero_image
          }.merge(params[:course].to_unsafe_h)
        end
      end
    end
  end
end
