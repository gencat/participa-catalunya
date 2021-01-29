# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe Admin::AdminUsers do
    subject { described_class.new(resource_bank) }

    let(:organization) { create :organization }
    let(:resource_bank) { create :resource_bank, organization: organization }
    let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }
    let!(:resource_bank_admin) do
      create(:user, :admin, :confirmed, organization: organization)
    end

    it "returns the organization admins and resource_bank admins" do
      expect(subject.query).to match_array([admin, resource_bank_admin])
    end
  end
end
