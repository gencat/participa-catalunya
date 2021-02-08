# frozen_string_literal: true

require "rails_helper"

describe "Layout" do
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
  end

  it "loads and shows organization name" do
    visit decidim.root_path

    expect(page).to have_content("Participa-Catalunya")
  end

  it "shows the FEDER logo" do
    visit decidim.root_path

    expect(page).to have_content("Fons Europeu de Desenvolupament Regional")
  end
end
