# frozen_string_literal: true

module Decidim
  module Courses
    class ExportCoursesJob < ApplicationJob
      queue_as :default

      def perform(user, format)
        export_data = Decidim::Exporters.find_exporter(format).new(collection, serializer).export

        ExportMailer.export(user, "courses", export_data).deliver_now
      end

      private

      def collection
        Decidim::Course.all
      end

      def serializer
        Decidim::Courses::CourseSerializer
      end
    end
  end
end
