# frozen_string_literal: true

require "spec_helper"

describe "Admin exports courses", type: :system do
  let!(:courses) do
    create_list(:course, 3, organization: organization)
  end
  let!(:course_no_images) { create :course, organization: organization, hero_image: nil, banner_image: nil }

  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when accessing courses list" do
    it "shows the export dropdown" do
      visit decidim_admin_courses.courses_path

      expect(page).to have_content("Export")
    end
  end

  context "when clicking the export dropdown" do
    before do
      visit decidim_admin_courses.courses_path
    end

    it "shows the export formats" do
      page.find(".exports").click

      expect(page).to have_content("Courses as JSON")
      expect(page).to have_content("Courses as CSV")
      expect(page).to have_content("Courses as EXCEL")
    end
  end

  context "when clicking the export link" do
    before do
      visit decidim_admin_courses.courses_path
      page.find(".exports").click
    end

    it "displays success message when exporting as JSON" do
      click_link "Courses as JSON"

      expect(page).to have_content("Your export is currently in progress. You'll receive an email when it's complete.")
    end

    it "displays success message when exporting as CSV" do
      click_link "Courses as CSV"

      expect(page).to have_content("Your export is currently in progress. You'll receive an email when it's complete.")
    end

    it "displays success message when exporting as EXCEL" do
      click_link "Courses as EXCEL"

      expect(page).to have_content("Your export is currently in progress. You'll receive an email when it's complete.")
    end
  end
end
