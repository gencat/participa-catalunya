# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ResourceBanks
    describe ResourceBankSearch do
      let(:organization) { create :organization }
      let(:scope) { create(:scope, organization: organization) }
      let(:scope2) { create(:scope, organization: organization) }
      let(:user1) { create(:user, organization: organization) }

      describe "results" do
        subject do
          described_class.new(
            search_text: search_text,
            current_user: user1,
            scope_id: scope_id,
            organization: organization
          ).results
        end

        let(:search_text) { nil }
        let(:scope_id) { nil }

        context "when the filter includes search_text" do
          let(:search_text) { "dog" }

          before do
            create_list(:resource_bank, 3, organization: organization)
            create(:resource_bank, title: { en: "A dog" }, organization: organization)
            create(:resource_bank, text: { en: "There is a dog in the office" }, organization: organization)
            create(:resource_bank, authorship: "By a dog", organization: organization)
          end

          it "returns the resource banks containing the search in the title or the body or the author name" do
            expect(subject.size).to eq(3)
          end

          context "when the search_text is a resource bank id" do
            let!(:resource_bank) { create(:resource_bank, organization: organization) }
            let(:search_text) { resource_bank.id.to_s }

            it "returns the resource bank with the searched id" do
              expect(subject).to contain_exactly(resource_bank)
            end
          end
        end

        context "when the filter includes scope_id" do
          let!(:resource_bank) { create(:resource_bank, scope: scope, organization: organization) }
          let!(:resource_bank2) { create(:resource_bank, scope: scope2, organization: organization) }

          context "when a scope id is being sent" do
            let(:scope_id) { [scope.id] }

            it "filters resource banks by scope" do
              expect(subject).to match_array [resource_bank]
            end
          end

          context "when multiple ids are sent" do
            let(:scope_id) { [scope.id, scope2.id] }

            it "filters resource banks by scope" do
              expect(subject).to match_array [resource_bank, resource_bank2]
            end
          end
        end
      end
    end
  end
end
