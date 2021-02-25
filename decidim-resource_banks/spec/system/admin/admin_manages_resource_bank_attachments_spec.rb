# frozen_string_literal: true

require "spec_helper"

describe "Admin manages resource attachments", type: :system do
  include_context "when admin administrating a resource"

  let(:attached_to) { resource_bank }
  let(:attachment_collection) { create(:attachment_collection, collection_for: resource_bank) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_resource_banks.edit_resource_bank_path(resource_bank)
    click_link "Files"
  end

  it_behaves_like "manage attachments examples"
end
