# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe DataPortabilityCourseRegistrationSerializer do
    let(:resource) { create(:course_registration) }
    let(:subject) { described_class.new(resource) }

    describe "#serialize" do
      it "includes the id" do
        expect(subject.serialize).to include(id: resource.id)
      end

      it "includes the user" do
        expect(subject.serialize[:user]).to(
          include(name: resource.user.name)
        )
        expect(subject.serialize[:user]).to(
          include(email: resource.user.email)
        )
      end

      it "includes the registration_type" do
        expect(subject.serialize[:registration_type]).to(
          include(title: resource.registration_type.title)
        )
        expect(subject.serialize[:registration_type]).to(
          include(price: resource.registration_type.price)
        )
      end

      it "includes the course" do
        expect(subject.serialize[:course]).to(
          include(title: resource.course.title)
        )

        expect(subject.serialize[:course]).to(
          include(description: resource.course.description)
        )

        expect(subject.serialize[:course]).to(
          include(modality: resource.course.modality)
        )

        expect(subject.serialize[:course]).to(
          include(address: resource.course.address)
        )
        expect(subject.serialize[:course]).to(
          include(schedule: resource.course.schedule)
        )

        expect(subject.serialize[:course]).to(
          include(start_date: resource.course.start_date)
        )

        expect(subject.serialize[:course]).to(
          include(end_date: resource.course.end_date)
        )

        expect(subject.serialize[:course]).to(
          include(duration: resource.course.duration)
        )
      end
    end
  end
end
