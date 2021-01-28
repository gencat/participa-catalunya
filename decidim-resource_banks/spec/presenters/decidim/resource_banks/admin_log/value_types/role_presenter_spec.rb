# frozen_string_literal: true

require "spec_helper"

describe Decidim::ResourceBanks::AdminLog::ValueTypes::RolePresenter, type: :helper do
  subject { described_class.new(value, helper) }

  let(:value) { Decidim::ResourceBankUserRole::ROLES.sample }

  describe "#present" do
    it "renders the translated value" do
      expect(subject.present).to eq t(value, scope: "decidim.admin.models.resource_bank_user_role.roles")
    end
  end
end
