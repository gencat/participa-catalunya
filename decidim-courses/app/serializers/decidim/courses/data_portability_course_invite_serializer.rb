# frozen_string_literal: true

module Decidim
  module Courses
    class DataPortabilityCourseInviteSerializer < Decidim::Exporters::Serializer
      # Serializes a course invite for data portability
      def serialize
        {
          id: resource.id,
          sent_at: resource.sent_at,
          accepted_at: resource.accepted_at,
          rejected_at: resource.rejected_at,
          user: {
            name: resource.user.name,
            email: resource.user.email
          },
          registration_type: {
            title: resource.registration_type.title,
            price: resource.registration_type.price
          },
          course: {
            title: resource.course.title,
            description: resource.course.description,
            modality: resource.course.modality,
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
