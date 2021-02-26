# frozen_string_literal: true

module Decidim
  module Courses
    #
    # Decorator for course invites
    #
    class CourseInvitePresenter < SimpleDelegator
      def status
        return I18n.t("accepted", scope: "decidim.courses.models.course_invite.status", at: I18n.l(accepted_at, format: :decidim_short)) if accepted_at.present?
        return I18n.t("rejected", scope: "decidim.courses.models.course_invite.status", at: I18n.l(rejected_at, format: :decidim_short)) if rejected_at.present?
        return I18n.t("sent", scope: "decidim.courses.models.course_invite.status") if sent_at.present?

        "-"
      end

      def status_html_class
        return "success" if accepted_at.present?
        return "danger" if rejected_at.present?
        return "warning" if sent_at.present?

        ""
      end
    end
  end
end
