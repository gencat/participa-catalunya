# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # This command is executed when the user joins a course.
      class ConfirmCourseRegistration < Rectify::Command
        # Initializes a JoinCourse Command.
        #
        # course_registration - The registration to be confirmed
        def initialize(course_registration, current_user)
          @course_registration = course_registration
          @current_user = current_user
        end

        # Creates a course registration if the course has registrations enabled
        # and there are available slots.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          @course_registration.with_lock do
            return broadcast(:invalid) unless can_join_course?

            confirm_registration
            send_email_confirmation
            send_notification_confirmation
          end
          broadcast(:ok)
        end

        private

        attr_reader :course, :user

        def confirm_registration
          extra_info = {
            resource: {
              title: @course_registration.course.title
            }
          }

          Decidim.traceability.perform_action!(
            "confirm",
            @course_registration,
            @current_user,
            extra_info
          ) do
            @course_registration.update!(confirmed_at: Time.current)
            @course_registration
          end
        end

        def can_join_course?
          @course_registration.course.registrations_enabled? && @course_registration.course.has_available_slots?
        end

        def send_email_confirmation
          Decidim::Courses::CourseRegistrationMailer.confirmation(
            @course_registration.user,
            @course_registration.course,
            @course_registration.registration_type
          ).deliver_later
        end

        def send_notification_confirmation
          Decidim::EventsManager.publish(
            event: "decidim.events.courses.course_registration_confirmed",
            event_class: Decidim::Courses::CourseRegistrationNotificationEvent,
            resource: @course_registration.course,
            affected_users: [@course_registration.user]
          )
        end
      end
    end
  end
end
