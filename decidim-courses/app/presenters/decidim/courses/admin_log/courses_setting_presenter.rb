# frozen_string_literal: true

module Decidim
  module Courses
    module AdminLog
      # This class holds the logic to present a `Decidim::CoursesSetting`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      #    CoursesSettingPresenter.new(action_log, view_helpers).present
      class CoursesSettingPresenter < Decidim::Log::BasePresenter
        private

        def action_string
          case action
          when "update"
            "decidim.admin_log.courses_setting.#{action}"
          end
        end
      end
    end
  end
end
