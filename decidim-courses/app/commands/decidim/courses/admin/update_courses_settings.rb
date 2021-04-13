# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A command that sets the settings for courses module.
      class UpdateCoursesSettings < Rectify::Command
        # Public: Initializes the command.
        #
        # courses_settings - A courses_setting object to update.
        # form - A form object with the params.
        def initialize(courses_settings, form)
          @courses_settings = courses_settings
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form or courses_settings isn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid? || courses_settings.invalid?

          update_courses_setting!

          broadcast(:ok)
        end

        private

        attr_reader :form, :courses_settings

        def update_courses_setting!
          Decidim.traceability.update!(
            @courses_settings,
            form.current_user,
            decidim_scope_id: form.decidim_scope_id
          )
        end
      end
    end
  end
end
