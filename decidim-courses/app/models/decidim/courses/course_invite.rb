# frozen_string_literal: true

module Decidim
  module Courses
    # The data store for an Invite in the Decidim::Courses component.
    class CourseInvite < ApplicationRecord
      include Decidim::Traceable
      include Decidim::Loggable
      include Decidim::DataPortability

      belongs_to :course, foreign_key: "decidim_course_id", class_name: "Decidim::Course"
      belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"
      belongs_to :registration_type, foreign_key: "decidim_course_registration_type_id", class_name: "Decidim::Courses::RegistrationType"

      validates :user, uniqueness: { scope: :course }

      def self.export_serializer
        Decidim::Courses::DataPortabilityConferenceInviteSerializer
      end

      def self.log_presenter_class_for(_log)
        Decidim::Courses::AdminLog::InvitePresenter
      end

      def self.user_collection(user)
        where(decidim_user_id: user.id)
      end

      def accept!
        update!(accepted_at: Time.current, rejected_at: nil)
      end

      def reject!
        update!(rejected_at: Time.current, accepted_at: nil)
      end
      alias decline! reject!
    end
  end
end
