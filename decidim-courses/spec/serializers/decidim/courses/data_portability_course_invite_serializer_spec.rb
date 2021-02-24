# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe DataPortabilityCourseInviteSerializer do
    let(:resource) { build_stubbed(:course_invite) }
    let(:subject) { described_class.new(resource) }

    describe "#serialize" do
      it "includes the invite data" do
        serialized = subject.serialize

        expect(serialized).to be_a(Hash)

        expect(subject.serialize).to include(id: resource.id)
        expect(subject.serialize).to include(sent_at: resource.sent_at)
        expect(subject.serialize).to include(accepted_at: resource.accepted_at)
        expect(subject.serialize).to include(rejected_at: resource.rejected_at)
      end

      it "includes the user" do
        serialized_user = subject.serialize[:user]

        expect(serialized_user).to be_a(Hash)

        expect(serialized_user).to include(name: resource.user.name)
        expect(serialized_user).to include(email: resource.user.email)
      end

      it "includes the registration_type" do
        serialized_registration_type = subject.serialize[:registration_type]

        expect(serialized_registration_type).to be_a(Hash)

        expect(serialized_registration_type).to include(title: resource.registration_type.title)
        expect(serialized_registration_type).to include(price: resource.registration_type.price)
      end

      it "includes the course" do
        serialized_course = subject.serialize[:course]

        expect(serialized_course).to be_a(Hash)

        expect(serialized_course).to include(title: resource.course.title)
        expect(serialized_course).to include(description: resource.course.description)
        expect(serialized_course).to include(modality: resource.course.modality)
        expect(serialized_course).to include(instructors: resource.course.instructors)
        expect(serialized_course).to include(address: resource.course.address)
        expect(serialized_course).to include(schedule: resource.course.schedule)
        expect(serialized_course).to include(start_date: resource.course.start_date)
        expect(serialized_course).to include(end_date: resource.course.end_date)
        expect(serialized_course).to include(duration: resource.course.duration)
      end
    end
  end
end
