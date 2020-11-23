# frozen_string_literal: true

require "spec_helper"

describe "Homepage courses content blocks", type: :system do
  let(:organization) { create(:organization) }

  let!(:past_course) do
    create(:course, course_date: 1.week.ago, organization: organization)
  end

  let!(:future_course) do
    create(:course, course_date: 1.week.from_now, organization: organization)
  end

  before do
    create :content_block, organization: organization, scope_name: :homepage, manifest_name: :upcoming_courses
    switch_to_host(organization.host)
  end

  it "includes future courses to the homepage" do
    visit decidim.root_path

    within "#upcoming-courses" do
      expect(page).to have_i18n_content(future_course.title)
      expect(page).not_to have_i18n_content(past_course.title)
    end
  end
end
