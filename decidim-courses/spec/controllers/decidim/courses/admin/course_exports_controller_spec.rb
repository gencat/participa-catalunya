# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    module Admin
      describe CourseExportsController, type: :controller do
        routes { Decidim::Courses::AdminEngine.routes }

        let!(:organization) { create(:organization) }
        let!(:course) { create :course, organization: organization }
        let!(:user) { create(:user, :admin, :confirmed, organization: organization) }

        let(:params) do
          {
            course_slug: course.slug
          }
        end

        before do
          request.env["decidim.current_organization"] = organization
          sign_in user, scope: :user
        end

        describe "POST create" do
          it "enqueues a job with the default format" do
            expect(ExportParticipatorySpaceJob).to receive(:perform_later)
              .with(user, course, "courses", "JSON")

            post(:create, params: params)
          end
        end
      end
    end
  end
end
