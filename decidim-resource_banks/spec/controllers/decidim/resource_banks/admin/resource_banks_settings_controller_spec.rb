# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ResourceBanks
    module Admin
      describe ResourceBanksSettingsController, type: :controller do
        routes { Decidim::ResourceBanks::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let(:current_user) { create(:user, :confirmed, :admin, organization: organization) }
        let(:scope) { create(:user, organization: organization) }
        let(:params) do
          {
            decidim_scope_id: scope.id
          }
        end

        before do
          request.env["decidim.current_organization"] = organization
          sign_in current_user
        end

        describe "when no settings were previously defined" do
          it "creates new resource banks settings" do
            post(:update, params: params)
            expect(flash[:alert]).to be_present
            expect(flash[:notice]).not_to be_present
          end
        end

        describe "when resource banks settings were already setted" do
          before do
            old_scope = create(:scope, organization: organization)
            Decidim::ResourcesSetting.create(organization: organization, scope: old_scope)
          end

          it "updates resource banks settings" do
            post(:update, params: params)
            expect(flash[:alert]).to be_present
            expect(flash[:notice]).not_to be_present
          end
        end
      end
    end
  end
end
