# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe ResourceBankCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/resource_banks/resource_bank", model).call }

    let(:model) { create(:resource_bank, :published) }

    it "renders the cell" do
      expect(subject).to have_css(".card--resource_bank")
    end
  end
end
