# frozen_string_literal: true

require "spec_helper"

describe "Explore Resource banks", type: :system do
  let(:organization) { create(:organization) }

  let(:resource_banks_count) { 5 }
  let!(:resource_banks) do
    create_list(:resource_bank, resource_banks_count, organization: organization)
  end

  before do
    switch_to_host(organization.host)
  end

  context "when filtering" do
    it "allows searching by text" do
      visit decidim_resource_banks.resource_banks_path

      within ".filters" do
        fill_in "filter[search_text]", with: translated(resource_banks.first.title)

        # The form should be auto-submitted when filter box is filled up, but
        # somehow it's not happening. So we workaround that be explicitly
        # clicking on "Search" until we find out why.
        find(".icon--magnifying-glass").click
      end

      expect(page).to have_css(".card--resource_bank", count: 1)
      expect(page).to have_content(translated(resource_banks.first.title))
    end

    it "allows filtering by scope" do
      scope = create(:scope, organization: organization)
      resource_bank = resource_banks.first
      resource_bank.scope = scope
      resource_bank.save

      visit decidim_resource_banks.resource_banks_path

      within ".filters .scope_id_check_boxes_tree_filter" do
        uncheck "All"
        uncheck "Global scope"
        check scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(".card--resource_bank", count: 1)
    end

    it "allows filtering by area" do
      area = create(:area, organization: organization)
      resource_bank = resource_banks.first
      resource_bank.area = area
      resource_bank.save

      visit decidim_resource_banks.resource_banks_path

      within ".filters" do
        select translated(area.name), from: "filter[area_id]"
      end

      expect(page).to have_css(".card--resource_bank", count: 1)
    end
  end

  context "when no resource banks published" do
    let!(:resource_banks) { [] }

    it "shows the correct warning" do
      visit decidim_resource_banks.resource_banks_path
      within ".callout" do
        expect(page).to have_content("any published resource")
      end
    end
  end

  context "when paginating" do
    before do
      Decidim::ResourceBank.destroy_all
    end

    def visit_component
      visit decidim_resource_banks.resource_banks_path
    end

    let!(:collection) { create_list :resource_bank, collection_size, organization: organization }
    let!(:resource_selector) { ".card--resource_bank" }

    it_behaves_like "a paginated resource"
  end
end
