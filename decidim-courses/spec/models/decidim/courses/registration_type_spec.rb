# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    describe RegistrationType do
      subject { registration_type }

      let(:registration_type) { build(:course_registration_type) }

      it { is_expected.to be_valid }
      it { is_expected.to be_versioned }

      describe ".default_scope" do
        it "returns registration types ordered by weight asc" do
          registration_type1 = create(:course_registration_type, price: 300.00, weight: 2, title: { en: "Registration type 1" })
          registration_type2 = create(:course_registration_type, price: 200.00, weight: 1, title: { en: "Registration type 2" })
          registration_type3 = create(:course_registration_type, price: 245.00, weight: 3, title: { en: "Registration type 3" })

          expected_result = [
            registration_type2,
            registration_type1,
            registration_type3
          ]

          expect(described_class.all).to eq expected_result
        end
      end

      describe "#participatory_space" do
        it "is an alias for #course" do
          expect(registration_type.course).to eq registration_type.participatory_space
        end
      end
    end
  end
end
