# frozen_string_literal: true

require "spec_helper"

describe "Admin manages resource_bank attachment collections examples", type: :system do
  include_context "when admin administrating a resource_bank"

  let(:collection_for) { resource_bank }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_resource_banks.edit_resource_bank_path(resource_bank)
    click_link "Folders"
  end

  it_behaves_like "manage attachment collections examples"
end
