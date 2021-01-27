# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A command to notify users when a role is assigned for an course
      class NotifyRoleAssignedToCourse < Rectify::Command
        def send_notification(user)
          Decidim::EventsManager.publish(
            event: "decidim.events.course.role_assigned",
            event_class: Decidim::RoleAssignedToCourseEvent,
            resource: form.current_participatory_space,
            affected_users: [user],
            extra: {
              role: form.role
            }
          )
        end
      end
    end
  end
end
