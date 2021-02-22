# frozen_string_literal: true

require "spec_helper"

describe "Admin manages resources", type: :system do
  include_context "when admin administrating a resource"

  let(:model_name) { resource_bank.class.model_name }

  shared_examples "creating a resource" do
    let(:image1_filename) { "city.jpeg" }
    let(:image1_path) { Decidim::Dev.asset(image1_filename) }

    let(:image2_filename) { "city2.jpeg" }
    let(:image2_path) { Decidim::Dev.asset(image2_filename) }

    before do
      click_link "New resource"
    end

    it "creates a new resource" do
      within ".new_resource_bank" do
        fill_in_i18n(
          :resource_bank_title,
          "#resource_bank-title-tabs",
          en: "My resource",
          es: "Mi recurso",
          ca: "El meu recurs"
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
        expect(page).to have_content("My resource")
      end
    end
  end

  shared_examples "manage resource announcement" do
    it "can customize an announcement for the resource" do
      click_link translated(resource_bank.title)

      fill_in_i18n_editor(
        :resource_bank_announcement,
        "#resource_bank-announcement-tabs",
        en: "An important announcement",
        es: "Un aviso muy importante",
        ca: "Un avís molt important"
      )

      within ".edit_resource_bank" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      visit decidim_admin_resource_banks.resource_banks_path

      within "tr", text: translated(resource_bank.title) do
        click_link "Preview"
      end

      expect(page).to have_content("An important announcement")
    end
  end

  context "when managing resources" do
    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_resource_banks.resource_banks_path
    end

    it_behaves_like "manage resource"
    it_behaves_like "manage resource announcement"
    it_behaves_like "creating a resource"

    describe "listing resources" do
      it_behaves_like "filtering collection by published/unpublished"
    end
  end
end
