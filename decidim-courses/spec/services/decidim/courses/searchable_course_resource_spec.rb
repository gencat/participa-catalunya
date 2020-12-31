# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Search do
    it_behaves_like "global search of participatory spaces" do
      let(:course) do
        create(
          :course,
          :unpublished,
          organization: organization,
          scope: scope1,
          title: Decidim::Faker::Localized.name,
          description: description_1
        )
      end
      let(:participatory_space) { course }
      let(:course2) do
        create(
          :course,
          organization: organization,
          scope: scope1,
          title: Decidim::Faker::Localized.name,
          description: description_2
        )
      end
      let(:participatory_space2) { course2 }
      let(:searchable_resource_attrs_mapper) do
        lambda { |space, locale|
          {
            "content_a" => I18n.transliterate(space.title[locale]),
            "content_b" => I18n.transliterate(space.description[locale]),
            "content_c" => "",
            "content_d" => ""
          }
        }
      end
    end
  end
end
