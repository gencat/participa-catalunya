# frozen_string_literal: true

require "spec_helper"

describe Decidim::Courses::AdminLog::RegistrationTypePresenter, type: :helper do
  include_examples "present admin log entry" do
    let(:course) { create(:course, organization: organization) }
    let(:admin_log_resource) { create(:course_registration_type, course: course) }
    let(:action) { "delete" }
  end
end
