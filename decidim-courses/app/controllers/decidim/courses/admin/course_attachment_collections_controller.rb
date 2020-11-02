# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # Controller that allows managing all the attachment collections for a course.
      #
      class CourseAttachmentCollectionsController < Decidim::Courses::Admin::ApplicationController
        include Concerns::CourseAdmin
        include Decidim::Admin::Concerns::HasAttachmentCollections

        def after_destroy_path
          course_attachment_collections_path(current_course)
        end

        def collection_for
          current_course
        end
      end
    end
  end
end
