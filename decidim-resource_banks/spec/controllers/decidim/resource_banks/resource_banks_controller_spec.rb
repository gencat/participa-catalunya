# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ResourceBanks
    describe ResourceBanksController, type: :controller do
      routes { Decidim::ResourceBanks::Engine.routes }

      let(:organization) { create(:organization) }

      let!(:unpublished_resource_bank) do
        create(
            :resource_bank,
            :unpublished,
            organization: organization
        )
      end

      let!(:published) do
        create(
            :resource_bank,
            :published,
            organization: organization
        )
      end

      let!(:promoted) do
        create(
            :resource_bank,
            :published,
            :promoted,
            organization: organization
        )
      end

      before do
        request.env["decidim.current_organization"] = organization
      end

      describe "published_resource_banks" do
        context "when there are no published resource_banks" do
          before do
            published.unpublish!
            promoted.unpublish!
          end

          it "redirects to 404" do
            expect { get :index }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      describe "promoted_resource_banks" do
        it "includes only promoted" do
          expect(controller.helpers.promoted_resource_banks).to contain_exactly(promoted)
        end
      end

      describe "resource_banks" do
        it "includes resource_banks, with promoted listed first" do
          expect(controller.helpers.resource_banks.first).to eq(promoted)
          expect(controller.helpers.resource_banks.second).to eq(published)
        end
      end
    end
  end
end
