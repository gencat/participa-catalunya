# frozen_string_literal: true

module Decidim
  module Courses
    class ParticipatorySpacePermissions < Decidim::DepartmentAdmin::Permissions
      def initialize(*)
        # This are the same permissions as Decidim's courses space.
        # Right now are the same for admin and public views
        self.class.delegate_chain = [Decidim::Courses::Permissions]

        super
      end

      def has_permission?(requested_action)
        allowed_actions = [
          # space
          -> { permission_for_current_space?(requested_action) },
          # courses
          -> { permission_for?(requested_action, :admin, :enter, :space_area, space_name: :courses) },
          -> { permission_for?(requested_action, :admin, :read, :course_list) },
          -> { permission_for?(requested_action, :admin, :create, :course) },
          -> { same_area_permission_for?(requested_action, :admin, :update, :course, restricted_rsrc: context[:course]) },
          -> { same_area_permission_for?(requested_action, :admin, :publish, :course, restricted_rsrc: context[:course]) },
          -> { same_area_permission_for?(requested_action, :admin, :unpublish, :course, restricted_rsrc: context[:course]) },
          # course_admins
          -> { permission_for?(requested_action, :admin, :index, :course_user_role) },
          -> { permission_for?(requested_action, :admin, :read, :course_user_role) },
          -> { permission_for?(requested_action, :admin, :create, :course_user_role) },
          -> { permission_for?(requested_action, :admin, :update, :course_user_role) },
          -> { permission_for?(requested_action, :admin, :invite, :course_user_role) },
          -> { permission_for?(requested_action, :admin, :destroy, :course_user_role) },
        ]

        allowed_actions.any?(&:call) || super
      end

      def permission_for_current_space?(permission_action)
        requested_space = context[:current_participatory_space].class.name
        return super unless requested_space == "Decidim::Course"

        allowed = permission_for?(permission_action, :admin, :read, :participatory_space)
        allowed || permission_for?(permission_action, :public, :read, :participatory_space)
      end
    end
  end
end
