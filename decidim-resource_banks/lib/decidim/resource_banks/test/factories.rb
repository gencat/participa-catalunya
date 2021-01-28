# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/faker/localized"
require "decidim/dev"

FactoryBot.define do
  sequence(:resource_bank_slug) do |n|
    "#{Faker::Internet.slug(nil, "-")}-#{n}"
  end

  factory :resource_bank, class: "Decidim::ResourceBank" do
    announcement { generate_localized_title }
    title { generate_localized_title }
    slug { generate(:resource_bank_slug) }
    text { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    authorship { Faker::Name.name }
    video_url { Faker::Internet.url }
    organization
    hero_image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") } # Keep after organization
    banner_image { Decidim::Dev.test_file("city2.jpeg", "image/jpeg") } # Keep after organization
    published_at { Time.current }
    hashtag { generate(:hashtag_name) }
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

  factory :resource_bank_user_role, class: "Decidim::ResourceBankUserRole" do
    user
    resource_bank { create :resource_bank, organization: user.organization }
    role { "admin" }
  end

  factory :resource_bank_admin, parent: :user, class: "Decidim::User" do
    transient do
      resource_bank { create(:resource_bank) }
    end

    organization { resource_bank.organization }

    after(:create) do |user, evaluator|
      create :resource_bank_user_role,
             user: user,
             resource_bank: evaluator.resource_bank,
             role: :admin
    end
  end
end
