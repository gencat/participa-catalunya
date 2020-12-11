# frozen_string_literal: true

require "spec_helper"
require "decidim/core/test/shared_examples/has_contextual_help"

describe "ResourceBanks", type: :system do
  let(:organization) { create(:organization) }
  let(:show_statistics) { false }
  let(:hashtag) { true }
  let(:base_resource_bank) do
    create(
      :resource_bank,
      organization: organization,
      text: { en: "Description", ca: "Descripció", es: "Descripción" },
      show_statistics: show_statistics
    )
  end

  before do
    switch_to_host(organization.host)
  end

  context "when there are no resource_banks and accessing from the homepage" do
    it "the menu link is not shown" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_no_content("Resource banks")
      end
    end
  end

  context "when the resource_bank does not exist" do
    it_behaves_like "a 404 page" do
      let(:target_path) { decidim_resource_banks.resource_bank_path(99_999_999) }
    end
  end

  context "when there are some resource_banks and all are unpublished" do
    before do
      create(:resource_bank, :unpublished, organization: organization)
      create(:resource_bank, :published)
    end

    context "and accessing from the homepage" do
      it "the menu link is not shown" do
        visit decidim.root_path

        within ".main-nav" do
          expect(page).to have_no_content("Resource banks")
        end
      end
    end
  end

  context "when there are some published resource_banks" do
    let!(:resource_bank) { base_resource_bank }
    let!(:promoted_resource_bank) { create(:resource_bank, :promoted, organization: organization) }
    let!(:unpublished_resource_bank) { create(:resource_bank, :unpublished, organization: organization) }

    it_behaves_like "editable content for admins" do
      let(:target_path) { decidim_resource_banks.resource_banks_path }
    end

    it_behaves_like "shows contextual help" do
      let(:index_path) { decidim_resource_banks.resource_banks_path }
      let(:manifest_name) { :resource_banks }
    end

    context "and requesting the resource_banks path" do
      before do
        visit decidim_resource_banks.resource_banks_path
      end

      context "and accessing from the homepage" do
        it "the menu link is shown" do
          visit decidim.root_path

          within ".main-nav" do
            expect(page).to have_content("Resource banks")
            click_link "Resource banks"
          end

          expect(page).to have_current_path decidim_resource_banks.resource_banks_path
        end
      end

      it "lists all the highlighted resource_banks" do
        within "#highlighted-resource_banks" do
          expect(page).to have_content(translated(promoted_resource_bank.title, locale: :en))
          expect(page).to have_selector(".card--full", count: 1)
        end
      end

      it "lists the resource_banks" do
        within "#resource_banks-count" do
          expect(page).to have_content("2")
        end

        within "#resource_banks" do
          expect(page).to have_content(translated(resource_bank.title, locale: :en))
          expect(page).to have_content(translated(promoted_resource_bank.title, locale: :en))
          expect(page).to have_selector(".card", count: 2)

          expect(page).not_to have_content(translated(unpublished_resource_bank.title, locale: :en))
        end
      end

      it "links to the individual resource_bank page" do
        first(".card__link", text: translated(resource_bank.title, locale: :en)).click

        expect(page).to have_current_path decidim_resource_banks.resource_bank_path(resource_bank)
      end
    end
  end

  context 'when going to the resource_bank page' do
    let!(:resource_bank) { base_resource_bank }

    it_behaves_like 'editable content for admins' do
      let(:target_path) { decidim_resource_banks.resource_bank_path(resource_bank) }
    end

    context 'when requesting the resource_banks path' do
      before do
        visit decidim_resource_banks.resource_bank_path(resource_bank)
      end

      context 'when requesting the resource_bank path' do
        it 'shows the details of the given resource_bank' do
          within 'main' do
            expect(page).to have_content(translated(resource_bank.title, locale: :en))
            expect(page).to have_content(translated(resource_bank.text, locale: :en))
            expect(page).to have_css("a[href='#{resource_bank.video_url}']")
            expect(page).to have_content(translated(resource_bank.authorship, locale: :en))
          end
        end

        it_behaves_like 'has attachments' do
          let(:attached_to) { resource_bank }
        end

        it_behaves_like 'has attachment collections' do
          let(:attached_to) { resource_bank }
          let(:collection_for) { resource_bank }
        end
      end
    end
  end
end
