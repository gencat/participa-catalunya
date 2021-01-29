# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ResourceBankUserRole do
    subject { resource_bank_user_role }

    let(:resource_bank_user_role) { build(:resource_bank_user_role, role: role) }
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

    context "when the resource_bank and user belong to different organizations" do
      let(:resource_bank_organization) { create(:organization) }
      let(:user_organization) { create(:organization) }

      let(:resource_bank) do
        build(
          :resource_bank,
          organization: resource_bank_organization
        )
      end

      let(:user) { create(:user, organization: user_organization) }

      let(:resource_bank_user_role) do
        build(
          :resource_bank_user_role,
          user: user,
          resource_bank: resource_bank,
          role: "admin"
        )
      end

      it { is_expected.not_to be_valid }
    end

    context "when a role already exists" do
      let(:resource_bank_user_role) do
        build(
          :resource_bank_user_role,
          role: existing_role.role,
          user: existing_role.user,
          resource_bank: existing_role.resource_bank
        )
      end

      let!(:existing_role) do
        create(:resource_bank_user_role, role: role)
      end

      it { is_expected.not_to be_valid }
    end
  end
end
