# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Search do
    it_behaves_like "global search of participatory spaces" do
      let(:resource_bank) do
        create(
          :resource_bank,
          :unpublished,
          organization: organization,
          scope: scope1,
          title: Decidim::Faker::Localized.name,
          text: description_1
        )
      end
      let(:participatory_space) { resource_bank }
      let(:resource_bank2) do
        create(
          :resource_bank,
          organization: organization,
          scope: scope1,
          title: Decidim::Faker::Localized.name,
          text: description_2
        )
      end
      let(:participatory_space2) { resource_bank2 }
      let(:searchable_resource_attrs_mapper) do
        lambda { |space, locale|
          {
            "content_a" => I18n.transliterate(space.title[locale]),
            "content_b" => I18n.transliterate(space.text[locale]),
            "content_c" => "",
            "content_d" => ""
          }
        }
      end
    end
  end
end
