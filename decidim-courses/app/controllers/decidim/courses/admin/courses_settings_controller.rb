# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # Controller that allows setting the root scope to be used.
      #
      class CoursesSettingsController < Decidim::Courses::Admin::ApplicationController
        layout "decidim/admin/courses"

        # GET /admin/courses_settings/edit
        def edit
          enforce_permission_to :edit, :courses_settings, courses_settings: current_courses_settings
          @form = courses_settings_form.from_model(current_courses_settings)
        end

        # PUT /admin/courses_settings/:id
        def update
          enforce_permission_to :update, :courses_settings, courses_settings: current_courses_settings

          @form = courses_settings_form
                  .from_params(params, courses_settings: current_courses_settings)

          UpdateCoursesSettings.call(current_courses_settings, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("courses_settings.update.success", scope: "decidim.admin")
              redirect_to edit_settings_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("courses_settings.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        private

        def current_courses_settings
          @current_courses_settings ||= Decidim::CoursesSetting.find_or_create_by!(decidim_organization_id: current_organization.id)
        end

        def courses_settings_form
          form(Decidim::Courses::Admin::CoursesSettingForm)
        end
      end
    end
  end
end
