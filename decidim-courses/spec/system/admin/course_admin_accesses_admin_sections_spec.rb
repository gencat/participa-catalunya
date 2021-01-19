# frozen_string_literal: true

require "spec_helper"

describe "Course admin accesses admin sections", type: :system do
  include_context "when course admin administrating a course"

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_courses.courses_path

    click_link translated(course.title)
  end

  it "can access all sections" do
    within ".secondary-nav" do
      expect(page).to have_content("Info")
      expect(page).to have_content("Attachments")
      expect(page).to have_content("Folders")
      expect(page).to have_content("Files")
      expect(page).to have_content("Course admins")
    end
  end
end
