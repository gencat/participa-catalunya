# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ResourceBanks
    module Admin
      describe ResourceBankUserRolesController, type: :controller do
        routes { Decidim::ResourceBanks::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let(:current_user) { create(:user, :confirmed, :admin, organization: organization) }
        let!(:resource_bank) do
          create(
            :resource_bank,
            :published,
            organization: organization
          )
        end

        before do
          request.env["decidim.current_organization"] = organization
          request.env["decidim.current_resource_bank"] = resource_bank
          sign_in current_user
        end

        describe "creates new resource_bank admin" do
          let(:new_resource_bank_admin_name) { "new resource_bank admin name" }
          let(:new_resource_bank_admin_email) { "resource_bank_admin@mail.com" }
          let(:new_resource_bank_admin_params) do
            {
              resource_bank_user_role: {
                name: new_resource_bank_admin_name,
                email: new_resource_bank_admin_email,
                role: "admin"
              },
              resource_bank_slug: resource_bank.slug
            }
          end

          describe "with a valid nickname" do
            it "create new admin successfully" do
              post(:create, params: new_resource_bank_admin_params)
              expect(response).to redirect_to(resource_bank_user_roles_path(resource_bank.slug))
              expect(flash[:notice]).to be_present
              expect(flash[:alert]).not_to be_present
            end
          end

          describe "with an invalid nickname" do
            let(:new_resource_bank_admin_name) { "new resource_bank (admin) name" }

            it "must detect invalid nickname chars" do
              post(:create, params: new_resource_bank_admin_params)
              expect(flash[:alert]).to be_present
              expect(flash[:notice]).not_to be_present
            end
          end
        end
      end
    end
  end
end
