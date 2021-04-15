# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A form object used to create resource bank user roles from the admin dashboard.
      #
      class ResourceBanksSettingForm < Form
        mimic :resource_banks_setting

        attribute :decidim_scope_id, Integer
        validates :scope, presence: true, if: proc { |object| object.decidim_scope_id.present? }

        def scope
          @scope ||= current_organization.scopes.find_by(id: decidim_scope_id)
        end
      end
    end
  end
end
