# frozen_string_literal: true

shared_examples "manage resource_banks" do
  describe "updating a resource_bank" do
    let(:image3_filename) { "city3.jpeg" }
    let(:image3_path) { Decidim::Dev.asset(image3_filename) }

    before do
      click_link translated(resource_bank.title)
    end

    it "updates a resource_bank" do
      fill_in_i18n(
        :resource_bank_title,
        "#resource_bank-title-tabs",
        en: "My new title",
        es: "Mi nuevo título",
        ca: "El meu nou títol"
      )

      attach_file :resource_bank_banner_image, image3_path

      within ".edit_resource_bank" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within ".container" do
        expect(page).to have_selector("input[value='My new title']")
        expect(page).to have_css("img[src*='#{image3_filename}']")
      end
    end
  end

  describe "updating a resource_bank without images" do
    before do
      click_link translated(resource_bank.title)
    end

    it "update a resource_bank without images does not delete them" do
      click_submenu_link "Info"
      click_button "Update"

      expect(page).to have_admin_callout("successfully")

      expect(page).to have_css("img[src*='#{resource_bank.hero_image.url}']")
      expect(page).to have_css("img[src*='#{resource_bank.banner_image.url}']")
    end
  end

  # describe "previewing resource_banks" do
  #   context "when the resource_bank is unpublished" do
  #     let!(:resource_bank) { create(:resource_bank, :unpublished, organization: organization) }

  #     it "allows the user to preview the unpublished resource_bank" do
  #       within find("tr", text: translated(resource_bank.title)) do
  #         click_link "Preview"
  #       end

  #       expect(page).to have_css(".process-header")
  #       expect(page).to have_content(translated(resource_bank.title))
  #     end
  #   end

  #   context "when the resource_bank is published" do
  #     let!(:resource_bank) { create(:resource_bank, organization: organization) }

  #     it "allows the user to preview the unpublished resource_bank" do
  #       within find("tr", text: translated(resource_bank.title)) do
  #         click_link "Preview"
  #       end

  #       expect(page).to have_current_path decidim_resource_banks.resource_bank_path(resource_bank)
  #       expect(page).to have_content(translated(resource_bank.title))
  #     end
  #   end
  # end

  # describe "viewing a missing resource_bank" do
  #   it_behaves_like "a 404 page" do
  #     let(:target_path) { decidim_admin_resource_banks.resource_bank_path(99_999_999) }
  #   end
  # end

  describe "publishing a resource_bank" do
    let!(:resource_bank) { create(:resource_bank, :unpublished, organization: organization) }

    before do
      click_link translated(resource_bank.title)
    end

    it "publishes the resource_bank" do
      click_link "Publish"
      expect(page).to have_content("successfully published")
      expect(page).to have_content("Unpublish")
      expect(page).to have_current_path decidim_admin_resource_banks.edit_resource_bank_path(resource_bank)

      resource_bank.reload
      expect(resource_bank).to be_published
    end
  end

  describe "unpublishing a resource_bank" do
    let!(:resource_bank) { create(:resource_bank, organization: organization) }

    before do
      click_link translated(resource_bank.title)
    end

    it "unpublishes the resource_bank" do
      click_link "Unpublish"
      expect(page).to have_content("successfully unpublished")
      expect(page).to have_content("Publish")
      expect(page).to have_current_path decidim_admin_resource_banks.edit_resource_bank_path(resource_bank)

      resource_bank.reload
      expect(resource_bank).not_to be_published
    end
  end

  context "when there are multiple organizations in the system" do
    let!(:external_resource_bank) { create(:resource_bank) }

    it "doesn't let the admin manage resource_banks form other organizations" do
      within "table" do
        expect(page).not_to have_content(external_resource_bank.title["en"])
      end
    end
  end
end
