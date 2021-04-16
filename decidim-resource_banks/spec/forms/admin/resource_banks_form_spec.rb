#  frozen_string_literal: true

require "spec_helper"

module Decidim
  module ResourceBanks
    module Admin
      describe Decidim::ResourceBanks::Admin::ResourceBankForm do
        subject do
          described_class.from_params(params).with_context(
            current_organization: organization
          )
        end

        let(:organization) { create(:organization) }
        let(:params) do
          {
            scope_id: scope&.id,
            slug: "random-slug",
            title: Decidim::Faker::Localized.sentence,
            text: Decidim::Faker::Localized.sentence,
            description: Decidim::Faker::Localized.sentence
          }
        end
        let(:scope) { create(:scope, organization: organization) }

        describe "scope" do
          context "when ResourcesSetting.scope has NOT been set" do
            it "is valid with any scope" do
              expect(subject).to be_valid
            end
          end

          context "when ResourcesSetting.scope HAS been set" do
            let(:settings_scope) { create(:scope, organization: organization) }

            before do
              Decidim::ResourcesSetting.create!(organization: organization, scope: settings_scope)
            end

            context "and NO scope (global) has been set" do
              before do
                params.delete(:scope_id)
              end

              it { is_expected.to be_invalid }
            end

            context "and the setted scope is in the same scope hierarchy" do
              let(:settings_scope) { scope }

              it { is_expected.to be_valid }
            end

            context "and the setted scope is in a different scope hierarchy" do
              it { is_expected.to be_invalid }
            end
          end
        end
      end
    end
  end
end
