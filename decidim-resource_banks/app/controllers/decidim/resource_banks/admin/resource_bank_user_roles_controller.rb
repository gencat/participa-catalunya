# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module Admin
      # Controller that allows managing resource_bank user roles.
      #
      class ResourceBankUserRolesController < Decidim::ResourceBanks::Admin::ApplicationController
        include Concerns::ResourceBankAdmin

        def index
          enforce_permission_to :index, :resource_bank_user_role
          @resource_bank_user_roles = collection
        end

        def new
          enforce_permission_to :create, :resource_bank_user_role
          @form = form(ResourceBankUserRoleForm).instance
        end

        def create
          enforce_permission_to :create, :resource_bank_user_role
          @form = form(ResourceBankUserRoleForm).from_params(params)

          CreateResourceBankAdmin.call(@form, current_user, current_resource_bank) do
            on(:ok) do
              flash[:notice] = I18n.t("resource_bank_user_roles.create.success", scope: "decidim.admin")
              redirect_to resource_bank_user_roles_path(current_resource_bank)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("resource_bank_user_roles.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          @user_role = collection.find(params[:id])
          enforce_permission_to :update, :resource_bank_user_role, user_role: @user_role
          @form = form(ResourceBankUserRoleForm).from_model(@user_role.user)
        end

        def update
          @user_role = collection.find(params[:id])
          enforce_permission_to :update, :resource_bank_user_role, user_role: @user_role
          @form = form(ResourceBankUserRoleForm).from_params(params)

          UpdateResourceBankAdmin.call(@form, @user_role) do
            on(:ok) do
              flash[:notice] = I18n.t("resource_bank_user_roles.update.success", scope: "decidim.admin")
              redirect_to resource_bank_user_roles_path(current_resource_bank)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("resource_bank_user_roles.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        def destroy
          @resource_bank_user_role = collection.find(params[:id])
          enforce_permission_to :destroy, :resource_bank_user_role, user_role: @resource_bank_user_role

          DestroyResourceBankAdmin.call(@resource_bank_user_role, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("resource_bank_user_roles.destroy.success", scope: "decidim.admin")
              redirect_to resource_bank_user_roles_path(current_resource_bank)
            end
          end
        end

        def resend_invitation
          @user_role = collection.find(params[:id])
          enforce_permission_to :invite, :resource_bank_user_role, user_role: @user_role

          InviteUserAgain.call(@user_role.user, "invite_admin") do
            on(:ok) do
              flash[:notice] = I18n.t("users.resend_invitation.success", scope: "decidim.admin")
            end

            on(:invalid) do
              flash[:alert] = I18n.t("users.resend_invitation.error", scope: "decidim.admin")
            end
          end

          redirect_to resource_bank_user_roles_path(current_resource_bank)
        end

        private

        def collection
          @collection ||= Decidim::ResourceBankUserRole
                          .includes(:user)
                          .where(resource_bank: current_resource_bank)
                          .order(:role, "decidim_users.name")
        end
      end
    end
  end
end
