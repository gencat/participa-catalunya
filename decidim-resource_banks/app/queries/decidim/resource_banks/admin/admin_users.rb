# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # A class used to find the admins for an resource_bank.
      class AdminUsers < Rectify::Query
        # Syntactic sugar to initialize the class and return the queried objects.
        #
        # resource_bank - an resource_bank that needs to find its resource_bank admins
        def self.for(resource_bank)
          new(resource_bank).query
        end

        # Initializes the class.
        #
        # resource_bank - an resource_bank that needs to find its resource_bank admins
        def initialize(resource_bank)
          @resource_bank = resource_bank
        end

        # Finds organization admins and the users with role admin for the given resource_bank.
        #
        # Returns an ActiveRecord::Relation.
        def query
          Decidim::User.where(id: organization_admins).or(resource_bank_user_admins)
        end

        private

        attr_reader :resource_bank

        def organization_admins
          resource_bank.organization.admins
        end

        def resource_bank_user_admins
          resource_bank_user_admin_ids = Decidim::ResourceBankUserRole
                                         .where(resource_bank: resource_bank, role: :admin)
                                         .pluck(:decidim_user_id)
          Decidim::User.where(id: resource_bank_user_admin_ids)
        end
      end
    end
  end
end
