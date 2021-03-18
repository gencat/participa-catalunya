# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A form object used to create course registration types from the admin dashboard.
      class RegistrationTypeForm < Form
        include TranslatableAttributes
        include Decidim::ApplicationHelper

        mimic :course_registration_type

        translatable_attribute :title, String
        translatable_attribute :description, String

        attribute :weight, Integer

        validates :title, :description, :weight, presence: true
        validates :weight, numericality: { greater_than_or_equal_to: 0 }
      end
    end
  end
end
