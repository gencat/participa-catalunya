# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe CourseRegistrationMailer, type: :mailer do
    include ActionView::Helpers::SanitizeHelper
    include Decidim::TranslationsHelper

    let(:organization) { create(:organization) }
    let(:course) { create(:course, organization: organization) }
    let(:user) { create(:user, organization: organization) }
    let(:registration_type) { create(:course_registration_type, course: course) }
    let(:course_registration) { create(:course_registration, course: course, registration_type: registration_type, user: user) }
    let(:mail_pending) { described_class.pending_validation(user, course, registration_type) }
    let(:mail) { described_class.confirmation(user, course, registration_type) }

    describe "pending validation" do
      let(:default_subject) { "Your course's registration is pending confirmation" }

      let(:default_body) { "You will receive the confirmation shortly" }

      it "expect subject and body" do
        expect(mail_pending.subject).to eq(default_subject)
        expect(mail_pending.body.encoded).to match(default_body)
      end
    end

    describe "confirmation" do
      let(:default_subject) { "Your course's registration has been confirmed" }

      let(:default_body) { "details in the attachment" }

      it "expect subject and body" do
        expect(mail.subject).to eq(default_subject)
        expect(mail.body.encoded).to match(default_body)
      end

      it "includes the course's details in a ics file" do
        expect(mail.attachments.length).to eq(1)
        attachment = mail.attachments.first
        expect(attachment.filename).to match(/course-calendar-info.ics/)

        events = Icalendar::Event.parse(attachment.read)
        event = events.first
        expect(event.summary).to eq(translated(course.title))
        expect(event.description).to eq(strip_tags(translated(course.description)))
        expect(event.dtstart.value.to_i).to eq(Icalendar::Values::DateTime.new(course.start_date).value.to_i)
        expect(event.dtend.value.to_i).to eq(Icalendar::Values::DateTime.new(course.end_date).value.to_i)
      end
    end
  end
end
