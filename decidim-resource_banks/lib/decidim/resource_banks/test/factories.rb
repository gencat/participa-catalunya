# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :resource_bank_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :resource_bank).i18n_name }
    manifest_name :resource_bank
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
