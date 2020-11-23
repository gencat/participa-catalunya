# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    module ContentBlocks
      describe UpcomingCoursesCell, type: :cell do
        controller Decidim::Courses::CoursesController

        let(:html) { cell("decidim/courses/content_blocks/upcoming_courses").call }
        let(:organization) { create(:organization) }
        let(:current_user) { create :user, :admin, :confirmed, organization: organization }

        before do
          expect(controller).to receive(:current_organization).at_least(:once).and_return(organization)
        end

        context "with courses" do
          let!(:course) { create(:course, course_date: 2.week.from_now, organization: organization) }

          it "renders the events" do
            expect(html).to have_css(".card", count: 1)
          end

          describe "upcoming courses" do
            subject { cell.upcoming_courses }

            let(:cell) { described_class.new(nil, context: { controller: controller }) }

            let!(:past_course) do
              create(:course, course_date: 1.week.ago, organization: organization)
            end

            let!(:first_course) do
              create(:course, course_date: course.course_date - 1.day, organization: organization)
            end

            it { is_expected.not_to include(past_course) }
            it { is_expected.to include(course) }
            it { is_expected.to include(first_course) }

            it "orders them correctly" do
              expect(subject.length).to eq(2)
              expect(subject.first).to eq(first_course)
              expect(subject.last).to eq(course)
            end

            context "with upcoming unpublished events" do
              let!(:course) do
                create(:course, :unpublished, course_date: 1.week.from_now, organization: organization)
              end
              let!(:first_course) do
                create(:course, :unpublished, course_date: course.course_date + 1.week, organization: organization)
              end

              it "renders nothing" do
                expect(subject.length).to eq(0)
              end
            end
          end
        end

        context "with no events" do
          it "renders nothing" do
            expect(html).to have_no_css(".upcoming-courses")
          end
        end
      end
    end
  end
end
