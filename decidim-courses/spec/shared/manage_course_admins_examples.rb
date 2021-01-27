# frozen_string_literal: true

shared_examples "manage course admins examples" do
  let(:other_user) { create :user, organization: organization, email: "my_email@example.org" }

  let!(:course_admin) do
    create :course_admin,
           :confirmed,
           organization: organization,
           course: course
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_courses.edit_course_path(course)
    click_link "Course admins"
  end

  it "shows course admin list" do
    within "#course_admins table" do
      expect(page).to have_content(course_admin.email)
    end
  end

  it "creates a new course admin" do
    find(".card-title a.new").click

    within ".new_course_user_role" do
      fill_in :course_user_role_email, with: other_user.email
      fill_in :course_user_role_name, with: "John Doe"
      select "Administrator", from: :course_user_role_role

      find("*[type=submit]").click
    end

    expect(page).to have_admin_callout("successfully")

    within "#course_admins table" do
      expect(page).to have_content(other_user.email)
    end
  end

  describe "when managing different users" do
    before do
      create(:course_user_role, course: course, user: other_user)
      visit current_path
    end

    it "updates a course admin" do
      within "#course_admins" do
        within find("#course_admins tr", text: other_user.email) do
          click_link "Edit"
        end
      end

      within ".edit_course_user_roles" do
        select "Admin", from: :course_user_role_role

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within "#course_admins table" do
        expect(page).to have_content("Administrator")
      end
    end

    it "deletes a course_user_role" do
      within find("#course_admins tr", text: other_user.email) do
        accept_confirm { click_link "Delete" }
      end

      expect(page).to have_admin_callout("successfully")

      within "#course_admins table" do
        expect(page).to have_no_content(other_user.email)
      end
    end

    context "when the user has not accepted the invitation" do
      before do
        form = Decidim::Courses::Admin::CourseUserRoleForm.from_params(
          name: "test",
          email: "test@example.org",
          role: "admin"
        )

        Decidim::Courses::Admin::CreateCourseAdmin.call(
          form,
          user,
          course
        )

        visit current_path
      end

      it "resends the invitation to the user" do
        within find("#course_admins tr", text: "test@example.org") do
          click_link "Resend invitation"
        end

        expect(page).to have_admin_callout("successfully")
      end
    end
  end
end
