# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe OrganizationResourceBanks do
    subject { described_class.new(organization) }

    let!(:organization) { create(:organization) }
    let!(:resource_banks) do
      create_list(:resource_bank, 3, organization: organization)
    end

    let!(:other_organization_resource_banks) do
      create_list(:resource_bank, 3)
    end

    describe "query" do
      it "includes the organization's resource_banks" do
        expect(subject).to include(*resource_banks)
      end

      it "excludes the external resource_banks" do
        expect(subject).not_to include(*other_organization_resource_banks)
      end
    end
  end
end
