# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe JoinCourse do
    subject { described_class.new(course, registration_type, user) }

    let(:registrations_enabled) { true }
    let(:available_slots) { 10 }
    let(:organization) { create :organization }
    let!(:course) { create :course, organization: organization, registrations_enabled: registrations_enabled, available_slots: available_slots }
    let!(:course_admin) { create :course_admin, course: course }
    let!(:registration_type) { create :course_registration_type, course: course }
    let(:user) { create :user, :confirmed, organization: organization }
    let(:participatory_space_admins) { course.admins }

    let(:user_notification) do
      {
        event: "decidim.events.courses.course_registration_validation_pending",
        event_class: CourseRegistrationNotificationEvent,
        resource: course,
        affected_users: [user]
      }
    end

    let(:admin_notification) do
      {
        event: "decidim.events.courses.course_registrations_over_percentage",
        event_class: CourseRegistrationsOverPercentageEvent,
        resource: course,
        followers: participatory_space_admins,
        extra: extra
      }
    end

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates a registration for the course and the user" do
        expect { subject.call }.to change(CourseRegistration, :count).by(1)
        last_registration = CourseRegistration.last
        expect(last_registration.user).to eq(user)
        expect(last_registration.course).to eq(course)
      end

      it "sends an email with the pending validation" do
        perform_enqueued_jobs { subject.call }

        email = last_email

        expect(email.subject).to include("pending")
        expect(email.body.encoded).to include(translated(registration_type.title))
      end

      it "sends a notification to the user with the pending validation" do
        expect(Decidim::EventsManager).to receive(:publish).with(user_notification)

        subject.call
      end

      context "and exists and invite for the user" do
        let!(:course_invite) { create(:course_invite, course: course, user: user) }

        it "marks the invite as accepted" do
          expect { subject.call }.to change { course_invite.reload.accepted_at }.from(nil).to(kind_of(Time))
        end
      end

      context "when the course available slots are occupied over the 50%" do
        let(:extra) { { percentage: 0.5 } }

        before do
          create_list :course_registration, (available_slots * 0.5).round - 1, course: course
        end

        it "also sends a notification to the process admins" do
          expect(Decidim::EventsManager).to receive(:publish).with(user_notification)
          expect(Decidim::EventsManager).to receive(:publish).with(admin_notification)

          subject.call
        end

        context "when the 50% is already met" do
          before do
            create :course_registration, course: course
          end

          it "doesn't notify it twice to the process admins" do
            expect(Decidim::EventsManager).not_to receive(:publish).with(admin_notification)

            subject.call
          end
        end
      end

      context "when the course available slots are occupied over the 80%" do
        let(:extra) { { percentage: 0.8 } }

        before do
          create_list :course_registration, (available_slots * 0.8).round - 1, course: course
        end

        it "also sends a notification to the process admins" do
          expect(Decidim::EventsManager).to receive(:publish).with(user_notification)
          expect(Decidim::EventsManager).to receive(:publish).with(admin_notification)

          subject.call
        end

        context "when the 80% is already met" do
          before do
            create_list :course_registration, (available_slots * 0.8).round, course: course
          end

          it "doesn't notify it twice to the process admins" do
            expect(Decidim::EventsManager).not_to receive(:publish).with(admin_notification)

            subject.call
          end
        end
      end

      context "when the course available slots are occupied over the 100%" do
        let(:extra) { { percentage: 1 } }

        before do
          create_list :course_registration, available_slots - 1, course: course
        end

        it "also sends a notification to the process admins" do
          expect(Decidim::EventsManager).to receive(:publish).with(user_notification)
          expect(Decidim::EventsManager).to receive(:publish).with(admin_notification)

          subject.call
        end
      end
    end

    context "when the course has not registrations enabled" do
      let(:registrations_enabled) { false }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the course has not enough available slots" do
      let(:available_slots) { 1 }

      before do
        create(:course_registration, course: course)
      end

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end
  end
end
