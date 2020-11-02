# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # Controller that allows managing all the attachments for a course.
      #
      class CourseAttachmentsController < Decidim::Courses::Admin::ApplicationController
        include Concerns::CourseAdmin
        include Decidim::Admin::Concerns::HasAttachments

        def after_destroy_path
          course_attachments_path(current_course)
        end

        def attached_to
          current_course
        end
      end
    end
  end
end
