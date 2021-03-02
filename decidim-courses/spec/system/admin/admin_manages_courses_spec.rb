# frozen_string_literal: true

require "spec_helper"

describe "Admin manages courses", type: :system do
  include_context "when admin administrating a course"

  let(:model_name) { course.class.model_name }

  shared_examples "creating a course" do
    let(:image1_filename) { "city.jpeg" }
    let(:image1_path) { Decidim::Dev.asset(image1_filename) }

    let(:image2_filename) { "city2.jpeg" }
    let(:image2_path) { Decidim::Dev.asset(image2_filename) }

    before do
      click_link "New course"
    end

    it "creates a new course" do
      within ".new_course" do
        fill_in_i18n(
          :course_title,
          "#course-title-tabs",
          en: "My course",
          es: "Mi proceso participativo",
          ca: "El meu procés participatiu"
        )
        fill_in_i18n_editor(
          :course_description,
          "#course-description-tabs",
          en: "A longer description",
          es: "Descripción más larga",
          ca: "Descripció més llarga"
        )

        fill_in :course_available_slots, with: 0
        fill_in :course_slug, with: "slug"
        fill_in :course_hashtag, with: "#hashtag"
        attach_file :course_hero_image, image1_path
        attach_file :course_banner_image, image2_path

        modality = ::Decidim::Course::MODALITIES.sample
        select t("decidim.courses.modality.#{modality}"), from: :course_modality

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within ".container" do
        expect(page).to have_current_path decidim_admin_courses.courses_path
        expect(page).to have_content("My course")
      end
    end
  end

  shared_examples "manage course announcement" do
    it "can customize an announcement for the course" do
      click_link translated(course.title)

      fill_in_i18n_editor(
        :course_announcement,
        "#course-announcement-tabs",
        en: "An important announcement",
        es: "Un aviso muy importante",
        ca: "Un avís molt important"
      )

      within ".edit_course" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      visit decidim_admin_courses.courses_path

      within "tr", text: translated(course.title) do
        click_link "Preview"
      end

      expect(page).to have_content("An important announcement")
    end
  end

  context "when managing courses" do
    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_courses.courses_path
    end

    it_behaves_like "manage courses"
    it_behaves_like "manage course announcement"
    it_behaves_like "creating a course"

    describe "listing courses" do
      it_behaves_like "filtering collection by published/unpublished"
    end
  end
end
