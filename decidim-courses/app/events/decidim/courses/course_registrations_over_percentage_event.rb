# frozen-string_literal: true

module Decidim
  module Courses
    class CourseRegistrationsOverPercentageEvent < Decidim::Events::SimpleEvent
      i18n_attributes :percentage

      def percentage
        extra["percentage"] * 100
      end
    end
  end
end
