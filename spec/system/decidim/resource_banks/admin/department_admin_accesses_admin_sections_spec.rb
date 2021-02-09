# frozen_string_literal: true

require "spec_helper"

describe "Department admin accesses resource bank admin sections", type: :system do
  let(:organization) { create(:organization) }
  let!(:area) { create(:area, organization: organization) }
  let!(:user) { create(:department_admin, :confirmed, organization: organization, area: area) }
  let!(:resource_bank) { create(:resource_bank, organization: organization, area: area) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_resource_banks.resource_banks_path

    click_link translated(resource_bank.title)
  end

  it "can access all sections" do
    within ".secondary-nav" do
      expect(page).to have_content("Info")
      expect(page).to have_content("Attachments")
      expect(page).to have_content("Folders")
      expect(page).to have_content("Files")
      expect(page).to have_content("Resource bank admins")
    end
  end
end
