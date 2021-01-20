# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe Admin::AdminUsers do
    subject { described_class.new(course) }

    let(:organization) { create :organization }
    let(:course) { create :course, organization: organization }
    let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }
    let!(:course_admin) do
      create(:user, :admin, :confirmed, organization: organization)
    end

    it "returns the organization admins and course admins" do
      expect(subject.query).to match_array([admin, course_admin])
    end
  end
end
