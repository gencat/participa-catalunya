# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # A class used to find the ResourceBanks that the given user has
    # the specific role privilege.
    class ResourceBanksWithUserRole < Rectify::Query
      # Syntactic sugar to initialize the class and return the queried objects.
      #
      # user - a User that needs to find which resource_banks can manage
      # role - (optional) a Symbol to specify the role privilege
      def self.for(user, role = :any)
        new(user, role).query
      end

      # Initializes the class.
      #
      # user - a User that needs to find which resource_banks can manage
      # role - (optional) a Symbol to specify the role privilege
      def initialize(user, role = :any)
        @user = user
        @role = role
      end

      # Finds the ResourceBanks that the given user has role privileges.
      # If the special role ':any' is provided it returns all resource_banks where
      # the user has some kind of role privilege.
      #
      # Returns an ActiveRecord::Relation.
      def query
        # Admin users have all role privileges for all organization resource_banks
        return ResourceBanks::OrganizationResourceBanks.new(user.organization).query if user.admin?

        ResourceBank.where(id: resource_bank_ids)
      end

      private

      attr_reader :user, :role

      def resource_bank_ids
        user_roles = ResourceBankUserRole.where(user: user) if role == :any
        user_roles = ResourceBankUserRole.where(user: user, role: role) if role != :any
        user_roles.pluck(:decidim_resource_bank_id)
      end
    end
  end
end
