# frozen_string_literal: true

require "rails_helper"

module Decidim::Courses
  describe Admin::CreateCourse do
    subject { described_class.new(form) }

    let(:organization) { create :organization }
    let(:current_user) { create :department_admin, :confirmed, organization: organization, area: area }
    let(:scope) { create :scope, organization: organization }
    let(:area) { create :area, organization: organization }

    let(:form) do
      Admin::CourseForm
        .from_params(
          announcement: { en: "title" },
          title: { en: "title" },
          description: { en: "description" },
          objectives: { en: "objectives" },
          addressed_to: { en: "addressed_to" },
          programme: { en: "programme" },
          professorship: { en: "professorship" },
          methodology: { en: "methodology" },
          seats: { en: "seats" },
          instructors: { en: "instructors" },
          slug: "slug",
          hashtag: "hashtag",
          hero_image: nil,
          banner_image: nil,
          promoted: nil,
          scopes_enabled: true,
          scope: scope,
          area: nil,
          show_statistics: false,
          duration: "duration",
          address: "address",
          start_date: 5.days.from_now,
          end_date: 10.days.from_now,
          schedule: "schedule",
          modality: Decidim::Course::MODALITIES.sample,
          registration_link: Faker::Internet.url
        )
        .with_context(
          current_user: current_user,
          current_organization: organization
        )
    end
    let(:invalid) { false }

    context "when everything is ok" do
      let(:course) { Decidim::Course.last }

      it "creates a course with the user area" do
        subject.call

        expect(course.area).to eq area
      end
    end
  end
end
