# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe OrganizationPublishedCourses do
    subject { described_class.new(organization) }

    let!(:organization) { create(:organization) }

    let!(:published_courses) do
      create_list(:course, 3, :published, organization: organization)
    end

    let!(:unpublished_courses) do
      create_list(:course, 3, :unpublished, organization: organization)
    end

    let!(:foreign_courses) do
      create_list(:course, 3, :published)
    end

    describe "query" do
      it "includes the organization's published courses" do
        expect(subject).to include(*published_courses)
      end

      it "excludes the organization's unpublished courses" do
        expect(subject).not_to include(*unpublished_courses)
      end

      it "excludes other organization's published courses" do
        expect(subject).not_to include(*foreign_courses)
      end
    end
  end
end
