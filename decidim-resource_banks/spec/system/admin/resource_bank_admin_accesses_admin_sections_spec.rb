# frozen_string_literal: true

require "spec_helper"

describe "Resource admin accesses admin sections", type: :system do
  include_context "when resource admin administrating a resource"

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
      expect(page).to have_content("Resource admins")
    end
  end
end
