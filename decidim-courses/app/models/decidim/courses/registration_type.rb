# frozen_string_literal: true

module Decidim
  module Courses
    # It represents a registration type of the course
    class RegistrationType < ApplicationRecord
      include Decidim::Publicable
      include Decidim::Traceable
      include Decidim::Loggable
      include Decidim::TranslatableResource

      translatable_fields :title, :description

      belongs_to :course, foreign_key: "decidim_course_id", class_name: "Decidim::Course"
      has_many :course_registrations, foreign_key: "decidim_course_registration_type_id", class_name: "Decidim::Courses::CourseRegistration", dependent: :destroy

      default_scope { order(weight: :asc) }

      alias participatory_space course

      def self.log_presenter_class_for(_log)
        Decidim::Courses::AdminLog::RegistrationTypePresenter
      end
    end
  end
end
