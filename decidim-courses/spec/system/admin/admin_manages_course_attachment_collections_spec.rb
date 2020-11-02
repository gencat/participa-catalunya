# frozen_string_literal: true

require "spec_helper"

describe "Admin manages course attachment collections examples", type: :system do
  include_context "when admin administrating a course"

  let(:collection_for) { course }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_courses.edit_course_path(course)
    click_link "Folders"
  end

  it_behaves_like "manage attachment collections examples"
end
