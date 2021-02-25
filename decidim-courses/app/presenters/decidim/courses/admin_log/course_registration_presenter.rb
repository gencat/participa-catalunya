# frozen_string_literal: true

module Decidim
  module Courses
    module AdminLog
      # This class holds the logic to present a `Decidim::Courses::CourseRegistration`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      #    CourseRegistrationPresenter.new(action_log, view_helpers).present
      class CourseRegistrationPresenter < Decidim::Log::BasePresenter
        private

        def diff_fields_mapping
          {
            confirmed_at: :date
          }
        end

        def i18n_labels_scope
          "activemodel.attributes.courses.course_registration"
        end

        def action_string
          case action
          when "confirm"
            "decidim.admin_log.courses.course_registration.#{action}"
          else
            super
          end
        end

        def diff_actions
          super + %w(delete)
        end
      end
    end
  end
end
