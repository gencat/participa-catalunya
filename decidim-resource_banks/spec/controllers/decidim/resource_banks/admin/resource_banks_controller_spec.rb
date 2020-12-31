# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks::Admin
  describe ResourceBanksController, type: :controller do
    routes { Decidim::ResourceBanks::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :confirmed, :admin, organization: organization) }
    let!(:resource_bank) { create(:resource_bank, :published, organization: organization) }

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_resource_bank"] = resource_bank
      sign_in current_user
    end

    describe "PATCH update" do
      let(:resource_bank_params) do
        {
          title: resource_bank.title,
          text: resource_bank.text,
          authorship: resource_bank.authorship,
          slug: resource_bank.slug,
          scopes_enabled: resource_bank.scopes_enabled
        }
      end

      it "uses the slug param as resource_bank id" do
        expect(ResourceBankForm).to receive(:from_params).with(hash_including(id: resource_bank.id.to_s)).and_call_original

        patch :update, params: { slug: resource_bank.id, resource_bank: resource_bank_params }

        expect(response).to redirect_to(edit_resource_bank_path(resource_bank.slug))
      end
    end
  end
end
