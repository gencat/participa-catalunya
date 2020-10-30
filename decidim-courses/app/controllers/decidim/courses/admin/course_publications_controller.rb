# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # Controller that allows managing course publications.
      #
      class CoursePublicationsController < Decidim::Courses::Admin::ApplicationController
        include Concerns::CourseAdmin

        def create
          enforce_permission_to :publish, :course, course: current_course

          PublishCourse.call(current_course, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("course_publications.create.success", scope: "decidim.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("course_publications.create.error", scope: "decidim.admin")
            end

            redirect_back(fallback_location: courses_path)
          end
        end

        def destroy
          enforce_permission_to :publish, :course, course: current_course

          UnpublishCourse.call(current_course, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("course_publications.destroy.success", scope: "decidim.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("course_publications.destroy.error", scope: "decidim.admin")
            end

            redirect_back(fallback_location: courses_path)
          end
        end
      end
    end
  end
end
