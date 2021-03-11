# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A command with all the business logic
      # to update a course in the system.
      class UpdateCourse < Rectify::Command
        # Public: Initializes the command.
        #
        # course - the Course to update
        # form - A form object with the params.
        def initialize(course, form)
          @course = course
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          update_course

          if @course.valid?
            broadcast(:ok, @course)
          else
            form.errors.add(:hero_image, @course.errors[:hero_image]) if @course.errors.include? :hero_image
            form.errors.add(:banner_image, @course.errors[:banner_image]) if @course.errors.include? :banner_image
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form, :course

        def update_course
          @course.assign_attributes(attributes)
          save_course if @course.valid?
        end

        def save_course
          transaction do
            @course.save!
            Decidim.traceability.perform_action!(:update, @course, form.current_user) do
              @course
            end
          end
        end

        def attributes
          {
            announcement: form.announcement,
            description: form.description,
            instructors: form.instructors,
            title: form.title,
            objectives: form.objectives,
            addressed_to: form.addressed_to,
            programme: form.programme,
            professorship: form.professorship,
            methodology: form.methodology,
            seats: form.seats,
            hashtag: form.hashtag,
            promoted: form.promoted,
            area: form.area,
            scope: form.scope,
            scopes_enabled: form.scopes_enabled,
            show_statistics: form.show_statistics,
            slug: form.slug,
            address: form.address,
            start_date: form.start_date,
            end_date: form.end_date,
            schedule: form.schedule,
            registrations_enabled: form.registrations_enabled,
            available_slots: form.available_slots || 0,
            registration_terms: form.registration_terms,
            duration: form.duration,
            modality: form.modality,
            registration_link: form.registration_link,
            hero_image: form.hero_image,
            remove_hero_image: form.remove_hero_image,
            banner_image: form.banner_image,
            remove_banner_image: form.remove_banner_image
          }
        end
      end
    end
  end
end
