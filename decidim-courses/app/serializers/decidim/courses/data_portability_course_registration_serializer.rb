# frozen_string_literal: true

module Decidim
  module Courses
    class DataPortabilityCourseRegistrationSerializer < Decidim::Exporters::Serializer
      # Serializes a registration for data portability
      def serialize
        {
          id: resource.id,
          user: {
            name: resource.user.name,
            email: resource.user.email
          },
          registration_type: {
            title: resource.registration_type.title
          },
          course: {
            title: resource.course.title,
            description: resource.course.description,
            modality: resource.course.modality,
            instructors: resource.course.instructors,
            address: resource.course.address,
            schedule: resource.course.schedule,
            start_date: resource.course.start_date,
            end_date: resource.course.end_date,
            duration: resource.course.duration
          }
        }
      end
    end
  end
end
