# frozen_string_literal: true

require "spec_helper"
require "decidim/core/test/shared_examples/has_contextual_help"

describe "Courses", type: :system do
  let(:organization) { create(:organization) }
  let(:show_statistics) { false }
  let(:hashtag) { true }
  let(:base_course) do
    create(
      :course,
      organization: organization,
      description: { en: "Description", ca: "Descripció", es: "Descripción" },
      show_statistics: show_statistics
    )
  end

  before do
    switch_to_host(organization.host)
  end

  context "when going to the course page" do
    let!(:course) { base_course }

    it_behaves_like "editable content for admins" do
      let(:target_path) { decidim_courses.course_path(course) }
    end

    context "when requesting the courses path" do
      before do
        visit decidim_courses.course_path(course)
      end

      context "when requesting the course path" do
        it "shows the details of the given course" do
          within "main" do
            expect(page).to have_content(translated(course.title, locale: :en))
            expect(page).to have_content(translated(course.description, locale: :en))
            expect(page).to have_content(translated(course.course_date, locale: :en))
            expect(page).to have_content(course.duration)
            expect(page).to have_content(translated(course.modality, locale: :en))
            expect(page).to have_content(course.hashtag)
          end
        end

        it_behaves_like "has attachments" do
          let(:attached_to) { course }
        end

        it_behaves_like "has attachment collections" do
          let(:attached_to) { course }
          let(:collection_for) { course }
        end
      end
    end
  end
end
