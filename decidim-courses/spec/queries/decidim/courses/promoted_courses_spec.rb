# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe PromotedCourses do
    subject { described_class.new }

    let!(:course) do
      create(:course)
    end

    let!(:promoted_course) do
      create(:course, :promoted)
    end

    describe "query" do
      it "only returns promoted courses" do
        expect(subject.count).to eq(1)
        expect(subject.pluck(:id)).to match_array([promoted_course.id])
      end
    end
  end
end
