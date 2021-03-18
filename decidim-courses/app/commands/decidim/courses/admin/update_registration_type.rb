# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A command with all the business logic when updating a course
      # registration type in the system.
      class UpdateRegistrationType < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        # registration_type - The RegistrationType to update
        def initialize(form, registration_type)
          @form = form
          @registration_type = registration_type
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?
          return broadcast(:invalid) unless registration_type

          update_registration_type!
          broadcast(:ok)
        end

        private

        attr_reader :form, :registration_type

        def update_registration_type!
          log_info = {
            resource: {
              title: registration_type.title
            },
            participatory_space: {
              title: registration_type.course.title
            }
          }

          Decidim.traceability.update!(
            registration_type,
            form.current_user,
            form.attributes.slice(
              :title,
              :description,
              :weight
            ),
            log_info
          )
        end
      end
    end
  end
end
