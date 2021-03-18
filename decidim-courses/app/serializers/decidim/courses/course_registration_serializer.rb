# frozen_string_literal: true

module Decidim
  module Courses
    class CourseRegistrationSerializer < Decidim::Exporters::Serializer
      # Serializes a course registration
      def serialize
        {
          id: resource.id,
          user: {
            name: resource.user.name,
            email: resource.user.email
          },
          registration_type: {
            title: resource.registration_type.title
          }
        }
      end
    end
  end
end
