# frozen_string_literal: true

require "rails_helper"

describe "Homepage customizations", type: :system do
  let(:organization) do
    create(
      :organization,
      name: "Participa-Catalunya",
      default_locale: :ca,
      available_locales: [:ca, :es]
    )
  end

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "loads and shows organization name" do
    visit decidim.root_path

    expect(page).to have_content("Participa-Catalunya")
  end

  it "renders the footer customizations" do
    within ".main-footer" do
      expect(page).to have_content("Descarrega els fitxers de dades obertes")
    end

    within "section.footer__subhero.extended.subhero.home-section" do
      expect(page).to have_content("Aquest projecte ha estat cofinançat pel Fons Europeu de Desenvolupament Regional de la Unió Europea")
    end
  end
end
