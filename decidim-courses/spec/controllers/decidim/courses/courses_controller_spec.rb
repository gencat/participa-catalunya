# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    describe CoursesController, type: :controller do
      routes { Decidim::Courses::Engine.routes }

      let(:organization) { create(:organization) }

      let!(:unpublished_course) do
        create(
            :course,
            :unpublished,
            organization: organization
        )
      end

      let!(:published) do
        create(
            :course,
            :published,
            organization: organization
        )
      end

      let!(:promoted) do
        create(
            :course,
            :published,
            :promoted,
            organization: organization
        )
      end

      before do
        request.env["decidim.current_organization"] = organization
      end

      describe "published_courses" do
        context "when there are no published courses" do
          before do
            published.unpublish!
            promoted.unpublish!
          end

          it "redirects to 404" do
            expect { get :index }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      describe "promoted_courses" do
        it "includes only promoted" do
          expect(controller.helpers.promoted_courses).to contain_exactly(promoted)
        end
      end

      describe "courses" do
        it "includes courses, with promoted listed first" do
          expect(controller.helpers.courses.first).to eq(promoted)
          expect(controller.helpers.courses.second).to eq(published)
        end
      end
    end
  end
end
