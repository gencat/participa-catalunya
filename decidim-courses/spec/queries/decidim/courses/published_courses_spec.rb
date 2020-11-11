# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe PublishedCourses do
    subject { described_class.new }

    let!(:published_course) do
      create(:course, :published)
    end

    let!(:unpublished_course) do
      create(:course, :unpublished)
    end

    describe "query" do
      it "only returns published courses" do
        expect(subject.count).to eq(1)
        expect(subject.pluck(:id)).to match_array([published_course.id])
      end
    end
  end
end
