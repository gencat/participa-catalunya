# frozen_string_literal: true

module Decidim
  module Courses
    # This command is executed when the user joins a course.
    class JoinCourse < Rectify::Command
      # Initializes a JoinCourse Command.
      #
      # course - The current instance of the course to be joined.
      # registration_type - The registration type selected to attend the course
      # user - The user joining the course.
      def initialize(course, registration_type, user)
        @course = course
        @registration_type = registration_type
        @user = user
      end

      # Creates a course registration if the course has registrations enabled
      # and there are available slots.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        course.with_lock do
          return broadcast(:invalid) unless can_join_course?

          create_registration
          accept_invitation
          send_email_pending_validation
          send_notification_pending_validation
          notify_admin_over_percentage
        end
        broadcast(:ok)
      end

      private

      attr_reader :course, :user

      def accept_invitation
        course.course_invites.find_by(user: user)&.accept!
      end

      def create_registration
        Decidim::Courses::CourseRegistration.create!(course: course, user: user, registration_type: @registration_type)
      end

      def can_join_course?
        course.registrations_enabled? && course.has_available_slots?
      end

      def send_email_pending_validation
        Decidim::Courses::CourseRegistrationMailer.pending_validation(user, course, @registration_type).deliver_later
      end

      def send_notification_pending_validation
        Decidim::EventsManager.publish(
          event: "decidim.events.courses.course_registration_validation_pending",
          event_class: Decidim::Courses::CourseRegistrationNotificationEvent,
          resource: @course,
          affected_users: [@user]
        )
      end

      def participatory_space_admins
        @course.admins
      end

      def notify_admin_over_percentage
        return send_notification_over(0.5) if occupied_slots_over?(0.5)
        return send_notification_over(0.8) if occupied_slots_over?(0.8)

        send_notification_over(1.0) if occupied_slots_over?(1.0)
      end

      def send_notification_over(percentage)
        Decidim::EventsManager.publish(
          event: "decidim.events.courses.course_registrations_over_percentage",
          event_class: Decidim::Courses::CourseRegistrationsOverPercentageEvent,
          resource: @course,
          followers: participatory_space_admins,
          extra: {
            percentage: percentage
          }
        )
      end

      def occupied_slots_over?(percentage)
        @course.remaining_slots == (@course.available_slots * (1 - percentage)).round
      end
    end
  end
end
