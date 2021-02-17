# frozen_string_literal: true

module Decidim
  module Courses
    # A custom mailer for sending notifications to users when
    # they join a course.
    class CourseRegistrationMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper
      include ActionView::Helpers::SanitizeHelper

      helper Decidim::ResourceHelper
      helper Decidim::TranslationsHelper
      helper Decidim::ApplicationHelper

      def pending_validation(user, course, registration_type)
        with_user(user) do
          @user = user
          @course = course
          @organization = @course.organization
          @locator = Decidim::ResourceLocatorPresenter.new(@course)
          @registration_type = registration_type

          subject = I18n.t("pending_validation.subject", scope: "decidim.courses.mailer.course_registration_mailer")
          mail(to: user.email, subject: subject)
        end
      end

      def confirmation(user, course, registration_type)
        with_user(user) do
          @user = user
          @course = course
          @organization = @course.organization
          @locator = Decidim::ResourceLocatorPresenter.new(@course)
          @registration_type = registration_type

          add_calendar_attachment

          subject = I18n.t("confirmation.subject", scope: "decidim.courses.mailer.course_registration_mailer")
          mail(to: user.email, subject: subject)
        end
      end

      private

      def add_calendar_attachment
        calendar = Icalendar::Calendar.new
        calendar.event do |event|
          event.dtstart = Icalendar::Values::DateTime.new(@course.start_date)
          event.dtend = Icalendar::Values::DateTime.new(@course.end_date)
          event.summary = translated_attribute @course.title
          event.description = strip_tags(translated_attribute(@course.description))
          event.url = @locator.url
        end

        attachments["course-calendar-info.ics"] = calendar.to_ical
      end
    end
  end
end
