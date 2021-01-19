# frozen_string_literal: true

require "spec_helper"

describe Decidim::Courses::AdminLog::CourseUserRolePresenter, type: :helper do
  include_examples "present admin log entry" do
    let(:admin_log_resource) { create(:course_user_role, user: user) }
    let(:action) { "delete" }
  end
end
