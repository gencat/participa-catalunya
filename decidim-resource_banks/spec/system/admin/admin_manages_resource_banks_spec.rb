# frozen_string_literal: true

require "spec_helper"

describe "Admin manages resource_banks", type: :system do
  include_context "when admin administrating a resource_bank"

  let(:model_name) { resource_bank.class.model_name }

  shared_examples "creating a resource_bank" do
    let(:image1_filename) { "city.jpeg" }
    let(:image1_path) { Decidim::Dev.asset(image1_filename) }

    let(:image2_filename) { "city2.jpeg" }
    let(:image2_path) { Decidim::Dev.asset(image2_filename) }

    before do
      click_link "New resource bank"
    end

    it "creates a new resource_bank" do
      within ".new_resource_bank" do
        fill_in_i18n(
          :resource_bank_title,
          "#resource_bank-title-tabs",
          en: "My resource_bank",
          es: "Mi proceso participativo",
          ca: "El meu procés participatiu"
        )
        fill_in_i18n_editor(
          :resource_bank_text,
          "#resource_bank-text-tabs",
          en: "A longer description",
          es: "Descripción más larga",
          ca: "Descripció més llarga"
        )

        fill_in :resource_bank_slug, with: "slug"
        fill_in :resource_bank_hashtag, with: "#hashtag"
        attach_file :resource_bank_hero_image, image1_path
        attach_file :resource_bank_banner_image, image2_path

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within ".container" do
        expect(page).to have_current_path decidim_admin_resource_banks.resource_banks_path
        expect(page).to have_content("My resource_bank")
      end
    end
  end

  context "when managing resource_banks" do
    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_resource_banks.resource_banks_path
    end

    it_behaves_like "manage resource_banks"
    it_behaves_like "creating a resource_bank"

    describe "listing resource_banks" do
      it_behaves_like "filtering collection by published/unpublished"
    end
  end
end
