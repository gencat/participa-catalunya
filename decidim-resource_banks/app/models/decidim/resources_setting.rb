# frozen_string_literal: true

module Decidim
  # Defines a relation between a user and an course, and what kind of relation
  # does the user have.
  class ResourcesSetting < ApplicationRecord
    include Decidim::Traceable
    include Decidim::Loggable

    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization"
    belongs_to :scope,
               foreign_key: "decidim_scope_id",
               class_name: "Decidim::Scope",
               optional: true

    def self.log_presenter_class_for(_log)
      Decidim::ResourceBanks::AdminLog::ResourceBanksSettingPresenter
    end
  end
end
