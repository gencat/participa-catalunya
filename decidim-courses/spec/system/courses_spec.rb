# frozen_string_literal: true

require "spec_helper"
require "decidim/core/test/shared_examples/has_contextual_help"

describe "Courses", type: :system do
  let(:organization) { create(:organization) }
  let(:show_statistics) { false }
  let(:hashtag) { true }
  let(:modality) { "online" }
  let(:base_course) do
    create(
      :course,
      :with_area,
      :with_scope,
      modality: modality,
      organization: organization,
      show_statistics: show_statistics
    )
  end

  before do
    switch_to_host(organization.host)
  end

  context "when there are no courses and accessing from the homepage" do
    it "the menu link is not shown" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_no_content("Courses")
      end
    end
  end

  context "when the course does not exist" do
    it_behaves_like "a 404 page" do
      let(:target_path) { decidim_courses.course_path(99_999_999) }
    end
  end

  context "when there are some courses and all are unpublished" do
    before do
      create(:course, :unpublished, organization: organization)
      create(:course, :published)
    end

    context "and accessing from the homepage" do
      it "the menu link is not shown" do
        visit decidim.root_path

        within ".main-nav" do
          expect(page).to have_no_content("Courses")
        end
      end
    end
  end

  context "when there are some published courses" do
    let!(:course) { base_course }
    let!(:promoted_course) { create(:course, :promoted, organization: organization) }
    let!(:unpublished_course) { create(:course, :unpublished, organization: organization) }

    it_behaves_like "editable content for admins" do
      let(:target_path) { decidim_courses.courses_path }
    end

    it_behaves_like "shows contextual help" do
      let(:index_path) { decidim_courses.courses_path }
      let(:manifest_name) { :courses }
    end

    context "and requesting the courses path" do
      before do
        visit decidim_courses.courses_path
      end

      context "and accessing from the homepage" do
        it "the menu link is shown" do
          visit decidim.root_path

          within ".main-nav" do
            expect(page).to have_content("Courses")
            click_link "Courses"
          end

          expect(page).to have_current_path decidim_courses.courses_path
        end
      end

      it "lists all the highlighted courses" do
        within "#highlighted-courses" do
          expect(page).to have_content(translated(promoted_course.title, locale: :en))
          expect(page).to have_selector(".card--full", count: 1)
        end
      end

      it "lists the courses" do
        within "#courses-count" do
          expect(page).to have_content("2")
        end

        within "#courses" do
          expect(page).to have_content(translated(course.title, locale: :en))
          expect(page).to have_content(translated(promoted_course.title, locale: :en))
          expect(page).to have_selector(".card", count: 2)

          expect(page).not_to have_content(translated(unpublished_course.title, locale: :en))
        end
      end

      it "links to the individual course page" do
        first(".card__link", text: translated(course.title, locale: :en)).click

        expect(page).to have_current_path decidim_courses.course_path(course)
      end
    end
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
            expect(page).to have_i18n_content(course.announcement)
            expect(page).to have_i18n_content(course.title)
            expect(page).to have_i18n_content(course.description)
            expect(page).to have_i18n_content(course.objectives)
            expect(page).to have_i18n_content(course.addressed_to)
            expect(page).to have_i18n_content(course.programme)
            expect(page).to have_i18n_content(course.professorship)
            expect(page).to have_i18n_content(course.methodology)
            expect(page).to have_i18n_content(course.seats)
            expect(page).to have_content(I18n.l(course.start_date, format: "%B"))
            expect(page).to have_content(I18n.l(course.end_date, format: "%d %B"))
            expect(page).to have_content(course.schedule)
            expect(page).to have_content(course.duration)
            expect(page).to have_content(I18n.t(course.modality, scope: "decidim.courses.modality"))
            expect(page).to have_content(course.hashtag)
            expect(page).not_to have_content(course.address)
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

      context "when course is blended" do
        let(:modality) { "blended" }

        it "show the address" do
          within "main" do
            expect(page).to have_content(course.address)
          end
        end
      end

      context "when course is face-to-face" do
        let(:modality) { "face-to-face" }

        it "show the address" do
          within "main" do
            expect(page).to have_content(course.address)
          end
        end
      end
    end
  end
end
