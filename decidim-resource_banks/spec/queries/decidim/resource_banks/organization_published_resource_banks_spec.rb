# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe OrganizationPublishedResourceBanks do
    subject { described_class.new(organization) }

    let!(:organization) { create(:organization) }

    let!(:published_resource_banks) do
      create_list(:resource_bank, 3, :published, organization: organization)
    end

    let!(:unpublished_resource_banks) do
      create_list(:resource_bank, 3, :unpublished, organization: organization)
    end

    let!(:foreign_resource_banks) do
      create_list(:resource_bank, 3, :published)
    end

    describe "query" do
      it "includes the organization's published resource_banks" do
        expect(subject).to include(*published_resource_banks)
      end

      it "excludes the organization's unpublished resource_banks" do
        expect(subject).not_to include(*unpublished_resource_banks)
      end

      it "excludes other organization's published resource_banks" do
        expect(subject).not_to include(*foreign_resource_banks)
      end
    end
  end
end
