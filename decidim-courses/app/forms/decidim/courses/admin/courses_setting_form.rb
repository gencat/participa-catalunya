# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A form object used to create course user roles from the admin dashboard.
      #
      class CoursesSettingForm < Form
        mimic :courses_setting

        attribute :decidim_scope_id, Integer
        validates :scope, presence: true, if: proc { |object| object.decidim_scope_id.present? }

        def scope
          @scope ||= current_organization.scopes.find_by(id: decidim_scope_id)
        end
      end
    end
  end
end
