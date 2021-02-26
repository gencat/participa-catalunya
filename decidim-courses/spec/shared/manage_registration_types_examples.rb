# frozen_string_literal: true

shared_examples "manage registration types examples" do
  let!(:registration_type) { create(:course_registration_type, course: course) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_courses.edit_course_path(course)
    click_link "Registration Types"
  end

  it "shows course registration types list" do
    within "#course_registration_types table" do
      expect(page).to have_content(translated(registration_type.title))
    end
  end

  describe "when managing other course registration types" do
    before do
      visit current_path
    end

    it "updates a course registration types" do
      within find("#course_registration_types tr", text: translated(registration_type.title)) do
        click_link "Edit"
      end

      within ".edit_registration_type" do
        fill_in_i18n(
          :course_registration_type_title,
          "#course_registration_type-title-tabs",
          en: "Registration type title",
          es: "Registration type title es",
          ca: "Registration type title ca"
        )

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")
      expect(page).to have_current_path decidim_admin_courses.course_registration_types_path(course)

      within "#course_registration_types table" do
        expect(page).to have_content("Registration type title")
      end
    end

    it "deletes the course registration type " do
      within find("#course_registration_types tr", text: translated(registration_type.title)) do
        accept_confirm { find("a.action-icon--remove").click }
      end

      expect(page).to have_admin_callout("successfully")

      within "#course_registration_types table" do
        expect(page).to have_no_content(translated(registration_type.title))
      end
    end
  end
end
