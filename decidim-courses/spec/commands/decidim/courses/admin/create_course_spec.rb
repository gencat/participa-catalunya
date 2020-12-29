# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe Admin::CreateCourse do
    subject { described_class.new(form) }

    let(:organization) { create :organization }
    let(:current_user) { create :user, :admin, :confirmed, organization: organization }
    let(:scope) { create :scope, organization: organization }
    let(:area) { create :area, organization: organization }
    let(:errors) { double.as_null_object }

    let(:form) do
      instance_double(
        Admin::CourseForm,
        current_user: current_user,
        current_organization: organization,
        invalid?: invalid,
        errors: errors,

        title: { en: "title" },
        description: { en: "description" },
        instructors: { en: "instructors" },
        slug: "slug",
        hashtag: "hashtag",
        hero_image: nil,
        banner_image: nil,
        promoted: nil,
        scopes_enabled: true,
        scope: scope,
        area: area,
        show_statistics: false,
        duration: "duration",
        address: "address",
        start_date: 5.days.from_now,
        end_date: 10.days.from_now,
        schedule: "schedule",
        modality: Decidim::Course::MODALITIES.sample,
        registration_link: Faker::Internet.url
      )
    end
    let(:invalid) { false }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the course is not persisted" do
      let(:invalid_course) do
        instance_double(
          Decidim::Course,
          persisted?: false,
          valid?: false,
          errors: {
            hero_image: "Image too big",
            banner_image: "Image too big"
          }
        ).as_null_object
      end

      before do
        allow(Decidim::ActionLogger).to receive(:log).and_return(true)
        expect(Decidim::Course).to receive(:create).and_return(invalid_course)
      end

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end

      it "adds errors to the form" do
        expect(errors).to receive(:add).with(:hero_image, "Image too big")
        expect(errors).to receive(:add).with(:banner_image, "Image too big")
        subject.call
      end
    end

    context "when everything is ok" do
      let(:course) { Decidim::Course.last }

      it "creates a course" do
        expect { subject.call }.to change { Decidim::Course.count }.by(1)
      end

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:create)
          .with(Decidim::Course, current_user, kind_of(Hash))
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
