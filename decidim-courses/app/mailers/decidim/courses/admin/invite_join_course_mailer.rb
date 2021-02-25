# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A custom mailer for sending an invitation to join a course to
      # an existing user.
      class InviteJoinCourseMailer < Decidim::ApplicationMailer
        include Decidim::TranslationsHelper
        include Decidim::SanitizeHelper

        helper Decidim::ResourceHelper
        helper Decidim::TranslationsHelper

        helper_method :routes

        # Send an email to an user to invite them to join a course.
        #
        # user - The user being invited
        # course - The course being joined.
        # invited_by - The user performing the invitation.
        def invite(user, course, registration_type, invited_by)
          with_user(user) do
            @user = user
            @course = course
            @invited_by = invited_by
            @organization = @course.organization
            @locator = Decidim::ResourceLocatorPresenter.new(@course)
            @registration_type = registration_type

            subject = I18n.t("invite.subject", scope: "decidim.courses.mailer.invite_join_course_mailer")
            mail(to: user.email, subject: subject)
          end
        end

        private

        def routes
          @routes ||= Decidim::EngineRouter.main_proxy(@course)
        end
      end
    end
  end
end
