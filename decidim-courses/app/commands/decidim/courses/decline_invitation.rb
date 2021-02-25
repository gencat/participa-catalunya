# frozen_string_literal: true

module Decidim
  module Courses
    # This command is executed when the user declines an invite to the course.
    class DeclineInvitation < Rectify::Command
      # Initializes a DeclineInvitation Command.
      #
      # course - The current instance of the course where user has been invited.
      # user - The user that declines their invitation
      def initialize(course, user)
        @course = course
        @user = user
      end

      # Creates a course registration if the course has registrations enabled
      # and there are available slots.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        return broadcast(:invalid) unless can_decline_invitation?

        decline_invitation

        broadcast(:ok)
      end

      private

      attr_reader :course, :user

      def decline_invitation
        invitation.decline!
      end

      def can_decline_invitation?
        course.registrations_enabled? && invitation.present?
      end

      def invitation
        @invitation ||= course.course_invites.find_by(user: user)
      end
    end
  end
end
