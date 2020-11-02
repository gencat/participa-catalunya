# frozen_string_literal: true

shared_examples "manage courses" do
  describe "updating a course" do
    let(:image3_filename) { "city3.jpeg" }
    let(:image3_path) { Decidim::Dev.asset(image3_filename) }
    let(:course_date) { Time.current + 1.day }

    before do
      click_link translated(course.title)
    end

    it "updates a course" do
      fill_in_i18n(
        :course_title,
        "#course-title-tabs",
        en: "My new title",
        es: "Mi nuevo título",
        ca: "El meu nou títol"
      )

      attach_file :course_banner_image, image3_path

      within ".edit_course" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within ".container" do
        expect(page).to have_selector("input[value='My new title']")
        expect(page).to have_css("img[src*='#{image3_filename}']")
      end
    end
  end

  describe "updating a course without images" do
    before do
      click_link translated(course.title)
    end

    it "update a course without images does not delete them" do
      click_submenu_link "Info"
      click_button "Update"

      expect(page).to have_admin_callout("successfully")

      expect(page).to have_css("img[src*='#{course.hero_image.url}']")
      expect(page).to have_css("img[src*='#{course.banner_image.url}']")
    end
  end

  # describe "previewing courses" do
  #   context "when the course is unpublished" do
  #     let!(:course) { create(:course, :unpublished, organization: organization) }

  #     it "allows the user to preview the unpublished course" do
  #       within find("tr", text: translated(course.title)) do
  #         click_link "Preview"
  #       end

  #       expect(page).to have_css(".process-header")
  #       expect(page).to have_content(translated(course.title))
  #     end
  #   end

  #   context "when the course is published" do
  #     let!(:course) { create(:course, organization: organization) }

  #     it "allows the user to preview the unpublished course" do
  #       within find("tr", text: translated(course.title)) do
  #         click_link "Preview"
  #       end

  #       expect(page).to have_current_path decidim_courses.course_path(course)
  #       expect(page).to have_content(translated(course.title))
  #     end
  #   end
  # end

  # describe "viewing a missing course" do
  #   it_behaves_like "a 404 page" do
  #     let(:target_path) { decidim_admin_courses.course_path(99_999_999) }
  #   end
  # end

  describe "publishing a course" do
    let!(:course) { create(:course, :unpublished, organization: organization) }

    before do
      click_link translated(course.title)
    end

    it "publishes the course" do
      click_link "Publish"
      expect(page).to have_content("successfully published")
      expect(page).to have_content("Unpublish")
      expect(page).to have_current_path decidim_admin_courses.edit_course_path(course)

      course.reload
      expect(course).to be_published
    end
  end

  describe "unpublishing a course" do
    let!(:course) { create(:course, organization: organization) }

    before do
      click_link translated(course.title)
    end

    it "unpublishes the course" do
      click_link "Unpublish"
      expect(page).to have_content("successfully unpublished")
      expect(page).to have_content("Publish")
      expect(page).to have_current_path decidim_admin_courses.edit_course_path(course)

      course.reload
      expect(course).not_to be_published
    end
  end

  context "when there are multiple organizations in the system" do
    let!(:external_course) { create(:course) }

    it "doesn't let the admin manage courses form other organizations" do
      within "table" do
        expect(page).not_to have_content(external_course.title["en"])
      end
    end
  end

  context "when the course has a scope" do
    let(:scope) { create(:scope, organization: organization) }

    before do
      course.update!(scopes_enabled: true, scope: scope)
    end

    it "disables the scope for the course" do
      click_link translated(course.title)

      uncheck :course_scopes_enabled

      expect(page).to have_selector("#course_scope_id.disabled")
      expect(page).to have_selector("#course_scope_id .picker-values div input[disabled]", visible: :all)

      within ".edit_course" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")
    end
  end
end
