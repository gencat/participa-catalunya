# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe PublishedResourceBanks do
    subject { described_class.new }

    let!(:published_resource_bank) do
      create(:resource_bank, :published)
    end

    let!(:unpublished_resource_bank) do
      create(:resource_bank, :unpublished)
    end

    describe "query" do
      it "only returns published resource_banks" do
        expect(subject.count).to eq(1)
        expect(subject.pluck(:id)).to match_array([published_resource_bank.id])
      end
    end
  end
end
