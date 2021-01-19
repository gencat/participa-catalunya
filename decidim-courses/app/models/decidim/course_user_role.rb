# frozen_string_literal: true

module Decidim
  # Defines a relation between a user and an course, and what kind of relation
  # does the user have.
  class CourseUserRole < ApplicationRecord
    include Traceable
    include Loggable

    belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User", optional: true
    belongs_to :course, foreign_key: "decidim_course_id", class_name: "Decidim::Course", optional: true
    alias participatory_space course

    ROLES = %w(admin).freeze
    validates :role, inclusion: { in: ROLES }, uniqueness: { scope: [:user, :course] }
    validate :user_and_course_same_organization

    def self.log_presenter_class_for(_log)
      Decidim::Courses::AdminLog::CourseUserRolePresenter
    end

    private

    # Private: check if the process and the user have the same organization
    def user_and_course_same_organization
      return if !course || !user

      errors.add(:course, :invalid) unless user.organization == course.organization
    end
  end
end
