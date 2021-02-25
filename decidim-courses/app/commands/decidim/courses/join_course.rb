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
        course.registrations_enabled?
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
    end
  end
end
