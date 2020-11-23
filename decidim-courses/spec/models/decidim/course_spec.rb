# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Course do
    subject { course }

    let(:course) { build(:course, slug: "my-slug") }

    it { is_expected.to be_valid }
    it { is_expected.to be_versioned }

    include_examples "publicable"
    include_examples "resourceable"

    context "when there's a course with the same slug in the same organization" do
      let!(:other_course) { create :course, organization: course.organization, slug: "my-slug" }

      it "is not valid" do
        expect(subject).not_to be_valid
        expect(subject.errors[:slug]).to eq ["has already been taken"]
      end
    end

    context "when there's a course with the same slug in another organization" do
      let!(:external_course) { create :course, slug: "my-slug" }

      it { is_expected.to be_valid }
    end

    describe "scopes" do
      describe "upcoming" do
        let!(:past_course) { create(:course, course_date: Time.current - 1.minute) }
        let!(:future_course) { create(:course, course_date: Time.current + 1.minute) }
        let!(:future_unpublished) { create(:course, :unpublished, course_date: Time.current + 1.minute) }

        it "returns the future ones" do
          expect(described_class.upcoming).to include future_course
          expect(described_class.upcoming).not_to include past_course
          expect(described_class.upcoming).not_to include future_unpublished
        end
      end
    end
  end
end
