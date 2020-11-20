# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe PromotedResourceBanks do
    subject { described_class.new }

    let!(:resource_bank) do
      create(:resource_bank)
    end

    let!(:promoted_resource_bank) do
      create(:resource_bank, :promoted)
    end

    describe "query" do
      it "only returns promoted resource_banks" do
        expect(subject.count).to eq(1)
        expect(subject.pluck(:id)).to match_array([promoted_resource_bank.id])
      end
    end
  end
end
