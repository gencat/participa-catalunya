# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses::Admin
  describe CoursesController, type: :controller do
    routes { Decidim::Courses::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :confirmed, :admin, organization: organization) }
    let!(:course) { create(:course, :published, organization: organization) }

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_course"] = course
      sign_in current_user
    end

    describe "PATCH update" do
      let(:course_params) do
        {
          title: course.title,
          description: course.description,
          modality: course.modality,
          slug: course.slug,
          scopes_enabled: course.scopes_enabled,
          registrations_enabled: course.registrations_enabled,
          available_slots: course.available_slots
        }
      end

      it "uses the slug param as course id" do
        expect(CourseForm).to receive(:from_params).with(hash_including(id: course.id.to_s)).and_call_original

        patch :update, params: { slug: course.id, course: course_params }

        expect(response).to redirect_to(edit_course_path(course.slug))
      end
    end
  end
end
