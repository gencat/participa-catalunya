# frozen_string_literal: true

require "spec_helper"

describe Decidim::ResourceBanks::AdminLog::ResourceBankUserRolePresenter, type: :helper do
  include_examples "present admin log entry" do
    let(:admin_log_resource) { create(:resource_bank_user_role, user: user) }
    let(:action) { "delete" }
  end
end
