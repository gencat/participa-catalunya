# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe Admin::ConfirmCourseRegistration do
    subject { described_class.new(course_registration, current_user) }

    let(:registrations_enabled) { true }
    let(:available_slots) { 10 }
    let(:organization) { create :organization }
    let!(:course) { create :course, organization: organization, registrations_enabled: registrations_enabled, available_slots: available_slots }
    let!(:current_user) { create :course_admin, course: course }
    let!(:registration_type) { create :course_registration_type, course: course }
    let(:user) { create :user, :confirmed, organization: organization }
    let!(:course_registration) { create :course_registration, :unconfirmed, course: course, registration_type: registration_type, user: user }

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "confirms the course registration for the user" do
        subject.call
        course_registration.reload

        expect(course_registration.user).to eq(user)
        expect(course_registration.course).to eq(course)
        expect(course_registration).to be_confirmed
      end

      it "sends an email confirming the registration" do
        perform_enqueued_jobs { subject.call }

        email = last_email

        expect(email.subject).to include("confirmed")

        attachment = email.attachments.first
        expect(attachment.read.length).to be_positive
        expect(attachment.mime_type).to eq("text/calendar")
        expect(attachment.filename).to match(/course-calendar-info.ics/)
      end

      it "sends a notification to the user with the pending validation" do
        expect(Decidim::EventsManager)
          .to receive(:publish)
          .with(
            event: "decidim.events.courses.course_registration_confirmed",
            event_class: Decidim::Courses::CourseRegistrationNotificationEvent,
            resource: course,
            affected_users: [user]
          )

        subject.call
      end
    end
  end
end
