# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    module Admin
      describe RegistrationTypeForm do
        subject(:form) { described_class.from_params(attributes).with_context(context) }

        let(:organization) { create :organization }
        let(:course) { create :course, organization: organization }
        let(:current_participatory_space) { course }
        let(:context) do
          {
            current_participatory_space: course,
            current_organization: organization
          }
        end

        let(:title) { Decidim::Faker::Localized.sentence }
        let(:weight) { 1 }
        let(:price) { 300.00 }
        let(:description) do
          {
            en: "Description",
            es: "Descripción",
            ca: "Descripció"
          }
        end
        let(:attributes) do
          {
            "course_registration_type" => {
              "title" => title,
              "weight" => weight,
              "description" => description,
              "price" => price
            }
          }
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "when title is missing" do
          let(:title) { nil }

          it { is_expected.to be_invalid }
        end

        context "when weight is missing" do
          let(:weight) { nil }

          it { is_expected.to be_invalid }
        end

        context "when description is missing" do
          let(:description) { nil }

          it { is_expected.to be_invalid }
        end

        context "when price is missing" do
          let(:price) { nil }

          it { is_expected.to be_valid }
        end

        context "when price is not number" do
          let(:price) { "blabla" }

          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
