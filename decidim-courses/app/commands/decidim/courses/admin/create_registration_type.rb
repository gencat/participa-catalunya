# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A command with all the business logic when creating a new registration type
      # in the system.
      class CreateRegistrationType < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        # current_user - The current user hwo do the action of create
        # course - The Course that will hold the registration type
        def initialize(form, current_user, course)
          @form = form
          @current_user = current_user
          @course = course
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          create_registration_type!
          broadcast(:ok)
        end

        private

        attr_reader :form, :course, :current_user

        def create_registration_type!
          log_info = {
            resource: {
              title: form.title
            },
            participatory_space: {
              title: course.title
            }
          }

          @registration_type = Decidim.traceability.create!(
            Decidim::Courses::RegistrationType,
            form.current_user,
            form.attributes.slice(
              :title,
              :description,
              :weight
            ).merge(
              course: course
            ),
            log_info
          )
        end
      end
    end
  end
end
