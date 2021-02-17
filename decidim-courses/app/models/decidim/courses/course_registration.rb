# frozen_string_literal: true

module Decidim
  module Courses
    # The data store for a Registration in the Decidim::Courses component.
    class CourseRegistration < ApplicationRecord
      include Decidim::DataPortability

      belongs_to :course, foreign_key: "decidim_course_id", class_name: "Decidim::Course"
      belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"
      belongs_to :registration_type, foreign_key: "decidim_course_registration_type_id", class_name: "Decidim::Courses::RegistrationType"

      validates :user, uniqueness: { scope: :course }

      scope :confirmed, -> { where.not(confirmed_at: nil) }

      def self.user_collection(user)
        where(decidim_user_id: user.id)
      end

      def self.export_serializer
        Decidim::Courses::DataPortabilityCourseRegistrationSerializer
      end

      def confirmed?
        confirmed_at.present?
      end

      def self.log_presenter_class_for(_log)
        Decidim::Courses::AdminLog::CourseRegistrationPresenter
      end
    end
  end
end
