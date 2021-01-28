# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A command to notify users when a role is assigned for an resource_bank
      class NotifyRoleAssignedToResourceBank < Rectify::Command
        def send_notification(user)
          Decidim::EventsManager.publish(
            event: "decidim.events.resource_bank.role_assigned",
            event_class: Decidim::RoleAssignedToResourceBankEvent,
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
