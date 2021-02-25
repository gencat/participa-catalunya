# frozen_string_literal: true

module Decidim
  module Courses
    # This command is executed when the user leaves a course.
    class LeaveCourse < Rectify::Command
      # Initializes a LeaveCourse Command.
      #
      # course - The current instance of the course to be left.
      # registration_type - The registration type selected to attend the course
      # user - The user leaving the course.
      def initialize(course, registration_type, user)
        @course = course
        @registration_type = registration_type
        @user = user
      end

      # Destroys a course registration if the course has registrations enabled
      # and the registration exists.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        @course.with_lock do
          return broadcast(:invalid) unless registration

          destroy_registration
        end
        broadcast(:ok)
      end

      private

      def registration
        @registration ||= Decidim::Courses::CourseRegistration.find_by(course: @course, user: @user, registration_type: @registration_type)
      end

      def destroy_registration
        registration.destroy!
      end
    end
  end
end
