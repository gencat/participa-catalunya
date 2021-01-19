# frozen_string_literal: true

require "spec_helper"

describe Decidim::Courses::AdminLog::ValueTypes::RolePresenter, type: :helper do
  subject { described_class.new(value, helper) }

  let(:value) { Decidim::CourseUserRole::ROLES.sample }

  describe "#present" do
    it "renders the translated value" do
      expect(subject.present).to eq t(value, scope: "decidim.admin.models.course_user_role.roles")
    end
  end
end
