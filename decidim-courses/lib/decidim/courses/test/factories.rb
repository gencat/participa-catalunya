# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/faker/localized"
require "decidim/dev"

FactoryBot.define do
  sequence(:course_slug) do |n|
    "#{Faker::Internet.slug(nil, "-")}-#{n}"
  end

  factory :course, class: "Decidim::Course" do
    announcement { generate_localized_title }
    title { generate_localized_title }
    slug { generate(:course_slug) }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    instructors { Decidim::Faker::Localized.localized { generate(:name) } }
    organization
    hero_image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") } # Keep after organization
    banner_image { Decidim::Dev.test_file("city2.jpeg", "image/jpeg") } # Keep after organization
    published_at { Time.current }
    hashtag { generate(:hashtag_name) }
    address { "#{Faker::Address.street_name}, #{Faker::Address.city}" }
    start_date { 1.week.from_now }
    end_date { 2.weeks.from_now }
    schedule { "schedule" }
    duration { "duration" }
    modality { Decidim::Course::MODALITIES.sample }
    registration_link { Faker::Internet.url }
    show_statistics { true }

    trait :promoted do
      promoted { true }
    end

    trait :unpublished do
      published_at { nil }
    end

    trait :published do
      published_at { Time.current }
    end

    trait :with_area do
      area { create :area, organization: organization }
    end

    trait :with_scope do
      scopes_enabled { true }
      scope { create :scope, organization: organization }
    end
  end
end
