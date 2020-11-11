# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    describe CourseSearch do
      let(:organization) { create :organization }
      let(:user1) { create(:user, organization: organization) }

      describe "results" do
        subject do
          described_class.new(
            modality: modality,
            current_user: user1,
            organization: organization
          ).results
        end

        let(:modality) { nil }

        context "when the filter includes modality" do
          let!(:course) { create(:course, modality: "online", organization: organization) }
          let!(:course2) { create(:course, modality: "face-to-face", organization: organization) }

          let(:modality) { "online" }

          it "filters courses by modality" do
            expect(subject).to match_array [course]
          end
        end
      end
    end
  end
end
