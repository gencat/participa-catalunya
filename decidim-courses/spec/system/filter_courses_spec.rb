# frozen_string_literal: true

require "spec_helper"

describe "Filter Courses", type: :system do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  context "when filtering parent courses by scope" do
    let!(:scope) { create :scope, organization: organization }
    let!(:course_with_scope) { create(:course, scope: scope, organization: organization) }
    let!(:course_without_scope) { create(:course, organization: organization) }

    context "and choosing a scope" do
      before do
        visit decidim_courses.courses_path(filter: { scope_id: scope.id })
      end

      it "lists all courses belonging to that scope" do
        within "#courses" do
          expect(page).to have_content(translated(course_with_scope.title))
          expect(page).not_to have_content(translated(course_without_scope.title))
        end
      end
    end
  end

  context "when filtering courses by modality" do
    let!(:course_online) { create(:course, modality: "online", organization: organization) }
    let!(:course_face_to_face) { create(:course, modality: "face-to-face", organization: organization) }

    before do
      visit decidim_courses.courses_path
    end

    context "and choosing a modality" do
      before do
        select I18n.t("modality.online", scope: "decidim.courses"), from: "filter[modality]"
      end

      it "lists all courses belonging to that modality" do
        within "#courses" do
          expect(page).to have_content(translated(course_online.title))
          expect(page).not_to have_content(translated(course_face_to_face.title))
        end
      end
    end
  end
end
