# frozen_string_literal: true

require "spec_helper"
require "decidim/core/test/shared_examples/space_cell_changes_button_text_cta"

module Decidim::Courses
  describe CourseMCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/courses/course_m", model).call }

    let(:model) { create(:course, :published) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(subject).to have_css(".card--course")
      end

      it "shows the course modality" do
        expect(subject).to have_content(t(model.modality, scope: "decidim.courses.modality"))
      end
    end
  end
end
