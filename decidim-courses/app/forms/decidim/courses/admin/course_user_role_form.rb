# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A form object used to create course user roles from the admin dashboard.
      #
      class CourseUserRoleForm < Form
        mimic :course_user_role

        attribute :name, String
        attribute :email, String
        attribute :role, String

        validates :name, :email, :role, presence: true
        validates :role, inclusion: { in: Decidim::CourseUserRole::ROLES }

        validates :name, format: { with: UserBaseEntity::REGEXP_NAME }

        def roles
          Decidim::CourseUserRole::ROLES.map do |role|
            [
              I18n.t(role, scope: "decidim.admin.models.course_user_role.roles"),
              role
            ]
          end
        end
      end
    end
  end
end
