# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe CourseUserRole do
    subject { course_user_role }

    let(:course_user_role) { build(:course_user_role, role: role) }
    let(:role) { "admin" }

    it { is_expected.to be_valid }
    it { is_expected.to be_versioned }

    context "when the role is admin" do
      let(:role) { "admin" }

      it { is_expected.to be_valid }
    end

    context "when the role does not exist" do
      let(:role) { "fake_role" }

      it { is_expected.not_to be_valid }
    end

    context "when the process and user belong to different organizations" do
      let(:course_organization) { create(:organization) }
      let(:user_organization) { create(:organization) }

      let(:course) do
        build(
          :course,
          organization: course_organization
        )
      end

      let(:user) { create(:user, organization: user_organization) }

      let(:course_user_role) do
        build(
          :course_user_role,
          user: user,
          course: course,
          role: "admin"
        )
      end

      it { is_expected.not_to be_valid }
    end

    context "when a role already exists" do
      let(:course_user_role) do
        build(
          :course_user_role,
          role: existing_role.role,
          user: existing_role.user,
          course: existing_role.course
        )
      end

      let!(:existing_role) do
        create(:course_user_role, role: role)
      end

      it { is_expected.not_to be_valid }
    end
  end
end
