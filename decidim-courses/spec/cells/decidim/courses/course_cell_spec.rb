# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe CourseCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/courses/course", model).call }

    let(:model) { create(:course, :published) }

    it "renders the cell" do
      expect(subject).to have_css(".card--course")
    end
  end
end
