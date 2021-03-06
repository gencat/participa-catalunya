# frozen_string_literal: true

require "rails_helper"

describe "Overrides and customizations" do
  it "before Decidim v0.24" do
    # ACTION ->
    # Check new sorting in menus and review sorting in modules

    # ACTION ->
    # Get rid of config/initializers/menus.rb if possible
    # make sure that Processes menu option is NOT rendered in any
    # nor in the public main menu
    # nor in the admin menu

    # ACTION ->
    # Get rid of translations added by https://github.com/decidim/decidim/pull/7653
    # These translations are in the files config/locales/??-conferences.yml

    expect(Decidim.version).to be < "0.24"
  end
end
