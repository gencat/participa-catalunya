# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe CourseRegistrationSerializer do
    let(:course_registration) { create(:course_registration) }
    let(:subject) { described_class.new(course_registration) }

    describe "#serialize" do
      it "includes the id" do
        expect(subject.serialize).to include(id: course_registration.id)
      end

      it "includes the user" do
        expect(subject.serialize[:user]).to(
          include(name: course_registration.user.name)
        )
        expect(subject.serialize[:user]).to(
          include(email: course_registration.user.email)
        )
      end

      it "includes the registration type" do
        expect(subject.serialize[:registration_type]).to(
          include(title: course_registration.registration_type.title)
        )
      end
    end
  end
end
