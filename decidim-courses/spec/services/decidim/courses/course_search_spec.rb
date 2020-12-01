# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    describe CourseSearch do
      let(:organization) { create :organization }
      let(:scope) { create(:scope, organization: organization) }
      let(:scope2) { create(:scope, organization: organization) }
      let(:user1) { create(:user, organization: organization) }

      describe "results" do
        subject do
          described_class.new(
            date: date,
            search_text: search_text,
            modality: modality,
            scope_id: scope_id,
            current_user: user1,
            organization: organization
          ).results
        end

        let(:date) { "upcoming" }
        let(:search_text) { nil }
        let(:modality) { nil }
        let(:scope_id) { nil }

        context "when the filter includes search_text" do
          let(:search_text) { "dog" }

          before do
            create_list(:course, 3, organization: organization)
            create(:course, title: { en: "A dog" }, organization: organization)
            create(:course, description: { en: "There is a dog in the office" }, organization: organization)
          end

          it "returns the courses containing the search in the title or the body" do
            expect(subject.size).to eq(2)
          end

          context "when the search_text is a course id" do
            let!(:course) { create(:course, organization: organization) }
            let(:search_text) { course.id.to_s }

            it "returns the course with the searched id" do
              expect(subject).to contain_exactly(course)
            end
          end
        end

        context "when the filter includes scope_id" do
          let!(:course) { create(:course, scope: scope, organization: organization) }
          let!(:course2) { create(:course, scope: scope2, organization: organization) }

          context "when a scope id is being sent" do
            let(:scope_id) { [scope.id] }

            it "filters courses by scope" do
              expect(subject).to match_array [course]
            end
          end

          context "when multiple ids are sent" do
            let(:scope_id) { [scope.id, scope2.id] }

            it "filters courses by scope" do
              expect(subject).to match_array [course, course2]
            end
          end
        end

        context "when the filter includes date" do
          let!(:course) do
            create(:course, course_date: 10.days.from_now, organization: organization)
          end

          let!(:past_course) do
            create(:course, course_date: 10.days.ago, organization: organization)
          end

          context "when upcoming" do
            let(:date) { "upcoming" }

            it "only returns that are scheduled in the future" do
              expect(subject).to match_array [course]
            end
          end

          context "when past" do
            let(:date) { "past" }

            it "only returns meetings that were scheduled in the past" do
              expect(subject).to match_array [past_course]
            end
          end
        end

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
