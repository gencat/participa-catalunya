# frozen_string_literal: true

require "spec_helper"

describe "Admin manages course attachments", type: :system do
  include_context "when admin administrating a course"

  let(:attached_to) { course }
  let(:attachment_collection) { create(:attachment_collection, collection_for: course) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_courses.edit_course_path(course)
    click_link "Files"
  end

  it_behaves_like "manage attachments examples"
end
