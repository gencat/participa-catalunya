# frozen_string_literal: true

module Decidim
  module Courses
    module Admin
      # A command with all the business logic when creating a new
      # course in the system.
      class CreateCourse < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
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

          if course.persisted?
            broadcast(:ok, course)
          else
            form.errors.add(:banner_image, course.errors[:banner_image]) if course.errors.include? :banner_image
            form.errors.add(:hero_image, course.errors[:hero_image]) if course.errors.include? :hero_image
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form

        def course
          @course ||= Decidim.traceability.create(
            Course,
            form.current_user,
            announcement: form.announcement,
            organization: form.current_organization,
            description: form.description,
            instructors: form.instructors,
            title: form.title,
            hashtag: form.hashtag,
            promoted: form.promoted,
            area: form.area,
            scope: form.scope,
            scopes_enabled: form.scopes_enabled,
            show_statistics: form.show_statistics,
            slug: form.slug,
            address: form.address,
            course_date: form.course_date,
            duration: form.duration,
            modality: form.modality,
            registration_link: form.registration_link,
            banner_image: form.banner_image,
            hero_image: form.hero_image
          )
        end
      end
    end
  end
end
