# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    describe CoursesController, type: :controller do
      routes { Decidim::Courses::Engine.routes }

      let(:organization) { create(:organization) }

      let!(:unpublished) do
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

      describe "GET index" do
        it "Only returns published courses" do
          get :index
          expect(subject.helpers.courses).to include(promoted, published)
          expect(subject.helpers.courses).not_to include(unpublished)
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
