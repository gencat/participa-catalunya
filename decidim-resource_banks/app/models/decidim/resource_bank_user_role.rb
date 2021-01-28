# frozen_string_literal: true

module Decidim
  # Defines a relation between a user and an resource_bank, and what kind of relation
  # does the user have.
  class ResourceBankUserRole < ApplicationRecord
    include Traceable
    include Loggable

    belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User", optional: true
    belongs_to :resource_bank, foreign_key: "decidim_resource_bank_id", class_name: "Decidim::ResourceBank", optional: true
    alias participatory_space resource_bank

    ROLES = %w(admin).freeze
    validates :role, inclusion: { in: ROLES }, uniqueness: { scope: [:user, :resource_bank] }
    validate :user_and_resource_bank_same_organization

    def self.log_presenter_class_for(_log)
      Decidim::ResourceBanks::AdminLog::ResourceBankUserRolePresenter
    end

    private

    # Private: check if the resource_bank and the user have the same organization
    def user_and_resource_bank_same_organization
      return if !resource_bank || !user

      errors.add(:resource_bank, :invalid) unless user.organization == resource_bank.organization
    end
  end
end
