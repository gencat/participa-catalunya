# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      class CourseExportsController < Decidim::Admin::ApplicationController
        include Concerns::CourseAdmin
        include Decidim::Admin::ParticipatorySpaceExport

        def exportable_space
          current_course
        end

        def manifest_name
          current_course.manifest.name.to_s
        end

        def after_export_path
          courses_path
        end
      end
    end
  end
end
