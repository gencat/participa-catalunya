# frozen_string_literal: true

require "spec_helper"

describe "Explore Courses", type: :system do
  let(:organization) { create(:organization) }

  let(:courses_count) { 5 }
  let!(:courses) do
    create_list(:course, courses_count, organization: organization, modality: "face-to-face")
  end

  before do
    switch_to_host(organization.host)
  end

  context "when filtering" do
    it "allows searching by text" do
      visit decidim_courses.courses_path

      within ".filters" do
        fill_in "filter[search_text]", with: translated(courses.first.title)

        # The form should be auto-submitted when filter box is filled up, but
        # somehow it's not happening. So we workaround that be explicitly
        # clicking on "Search" until we find out why.
        find(".icon--magnifying-glass").click
      end

      expect(page).to have_css(".card--course", count: 1)
      expect(page).to have_content(translated(courses.first.title))
    end

    it "allows filtering by date" do
      past_course = create(:course, organization: organization, course_date: 1.day.ago)

      visit decidim_courses.courses_path

      within ".filters" do
        choose "Past"
      end

      expect(page).to have_css(".card--course", count: 1)
      expect(page).to have_content(translated(past_course.title))

      within ".filters" do
        choose "Upcoming"
      end

      expect(page).to have_css(".card--course", count: 5)
    end

    it "allows filtering by scope" do
      scope = create(:scope, organization: organization)
      course = courses.first
      course.scope = scope
      course.save

      visit decidim_courses.courses_path

      within ".filters .scope_id_check_boxes_tree_filter" do
        uncheck "All"
        uncheck "Global scope"
        check scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(".card--course", count: 1)
    end

    it "allows filtering by modality" do
      course = courses.first
      course.modality = "online"
      course.save

      visit decidim_courses.courses_path

      within ".filters .modality_check_boxes_tree_filter" do
        uncheck "All"
        check I18n.t("modality.online", scope: "decidim.courses")
      end

      expect(page).to have_css(".card--course", count: 1)
      expect(page).to have_content(translated(course.title))
    end
  end

  context "when no upcoming courses scheduled" do
    let!(:courses) do
      create_list(:course, 2, organization: organization, course_date: Time.current - 4.days)
    end

    it "only shows the past meetings" do
      visit decidim_courses.courses_path
      expect(page).to have_css(".card--course", count: 2)
    end

    it "shows the correct warning" do
      visit decidim_courses.courses_path
      within ".callout" do
        expect(page).to have_content("no scheduled courses")
      end
    end
  end

  context "when no courses scheduled" do
    let!(:courses) { [] }

    it "shows the correct warning" do
      visit decidim_courses.courses_path
      within ".callout" do
        expect(page).to have_content("any course scheduled")
      end
    end
  end

  context "when paginating" do
    before do
      Decidim::Course.destroy_all
    end

    def visit_component
      visit decidim_courses.courses_path
    end

    let!(:collection) { create_list :course, collection_size, organization: organization }
    let!(:resource_selector) { ".card--course" }

    it_behaves_like "a paginated resource"
  end
end
