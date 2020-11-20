# frozen_string_literal: true

require "spec_helper"
require "decidim/core/test/shared_examples/space_cell_changes_button_text_cta"

module Decidim::ResourceBanks
  describe ResourceBankMCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/resource_banks/resource_bank_m", model).call }

    let(:model) { create(:resource_bank, :published) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(subject).to have_css(".card--resource_bank")
      end

      it "shows the resource_bank authorship" do
        expect(subject).to have_content(model.authorship)
      end
    end
  end
end
