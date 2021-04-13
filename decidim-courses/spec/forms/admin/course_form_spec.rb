# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    module Admin
      describe Decidim::Courses::Admin::CourseForm do
        subject do
          described_class.from_params(params).with_context(
            current_organization: organization
          )
        end

        let(:organization) { create(:organization) }
        let(:params) do
          {
            modality: ::Decidim::Course::MODALITIES.first,
            scope_id: scope.id,
            slug: "random-slug",
            title: Decidim::Faker::Localized.sentence,
            description: Decidim::Faker::Localized.sentence
          }
        end
        let(:scope) { create(:scope, organization: organization) }

        describe "scope" do
          context "when CoursesSetting.scope has NOT been set" do
            it "is valid with any scope" do
              expect(subject).to be_valid
            end
          end

          context "when CoursesSetting.scope HAS been set" do
            before do
              Decidim::CoursesSetting.create!(organization: organization, scope: settings_scope)
            end

            context "and the setted scope is in the same scope hierarchy" do
              let(:settings_scope) { scope }

              it { is_expected.to be_valid }
            end

            context "and the setted scope is in a different scope hierarchy" do
              let(:settings_scope) { create(:scope, organization: organization) }

              it { is_expected.to be_invalid }
            end
          end
        end
      end
    end
  end
end
