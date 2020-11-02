# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe OrganizationCourses do
    subject { described_class.new(organization) }

    let!(:organization) { create(:organization) }
    let!(:courses) do
      create_list(:course, 3, organization: organization)
    end

    let!(:other_organization_courses) do
      create_list(:course, 3)
    end

    describe "query" do
      it "includes the organization's courses" do
        expect(subject).to include(*courses)
      end

      it "excludes the external courses" do
        expect(subject).not_to include(*other_organization_courses)
      end
    end
  end
end
