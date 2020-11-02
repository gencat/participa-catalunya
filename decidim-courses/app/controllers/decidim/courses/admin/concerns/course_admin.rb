# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Courses
    module Admin
      module Concerns
        # This concern is meant to be included in all controllers that are scoped
        # into an course's admin panel. It will override the layout so it shows
        # the sidebar, preload the course, etc.
        module CourseAdmin
          extend ActiveSupport::Concern

          RegistersPermissions
            .register_permissions(::Decidim::Courses::Admin::Concerns::CourseAdmin,
                                  Decidim::Courses::Permissions,
                                  Decidim::Admin::Permissions)

          included do
            include Decidim::Admin::ParticipatorySpaceAdminContext
            participatory_space_admin_layout

            helper_method :current_course

            def current_course
              @current_course ||= organization_courses.find_by!(
                slug: params[:course_slug] || params[:slug]
              )
            end

            alias_method :current_participatory_space, :current_course

            def organization_courses
              @organization_courses ||= OrganizationCourses.new(current_organization).query
            end

            def permissions_context
              super.merge(current_participatory_space: current_participatory_space)
            end

            def permission_class_chain
              PermissionsRegistry.chain_for(CourseAdmin)
            end
          end
        end
      end
    end
  end
end
