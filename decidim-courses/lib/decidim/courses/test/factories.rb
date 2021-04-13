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
    objectives { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    addressed_to { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    programme { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    professorship { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    methodology { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
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
    registrations_enabled { true }
    registration_terms { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    available_slots { 0 }
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

  factory :course_user_role, class: "Decidim::CourseUserRole" do
    user
    course { create :course, organization: user.organization }
    role { "admin" }
  end

  factory :course_admin, parent: :user, class: "Decidim::User" do
    transient do
      course { create(:course) }
    end

    organization { course.organization }

    after(:create) do |user, evaluator|
      create :course_user_role,
             user: user,
             course: evaluator.course,
             role: :admin
    end
  end

  factory :course_registration_type, class: "Decidim::Courses::RegistrationType" do
    course

    title { generate_localized_title }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    published_at { Time.current }
    weight { Faker::Number.between(1, 10) }

    trait :unpublished do
      published_at { nil }
    end

    trait :published do
      published_at { Time.current }
    end
  end

  factory :course_registration, class: "Decidim::Courses::CourseRegistration" do
    course
    user
    registration_type factory: :course_registration_type
    confirmed_at { Time.current }

    trait :confirmed do
      confirmed_at { Time.current }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end

  factory :course_invite, class: "Decidim::Courses::CourseInvite" do
    course
    user
    sent_at { Time.current - 1.day }
    accepted_at { nil }
    rejected_at { nil }
    registration_type factory: :course_registration_type

    trait :accepted do
      accepted_at { Time.current }
    end

    trait :rejected do
      rejected_at { Time.current }
    end
  end
end
