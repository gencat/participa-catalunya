# frozen_string_literal: true

require "rails_helper"

module Decidim::Courses
  describe Admin::UpdateCourse do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:my_course) { create :course, organization: organization }
      let(:area) { create(:area, organization: organization) }
      let(:user) { create :department_admin, :confirmed, organization: my_course.organization, area: area }

      let(:params) do
        {
          course: {
            id: my_course.id,
            current_organization: my_course.organization,
            errors: my_course.errors,
            announcement_en: "Announcement en",
            announcement_ca: "Announcement ca",
            announcement_es: "Announcement es",
            title_en: "Title en",
            title_ca: "Title ca",
            title_es: "Title es",
            description_en: my_course.description,
            description_ca: my_course.description,
            description_es: my_course.description,
            objectives_en: my_course.objectives,
            objectives_ca: my_course.objectives,
            objectives_es: my_course.objectives,
            addressed_to_en: my_course.addressed_to,
            addressed_to_ca: my_course.addressed_to,
            addressed_to_es: my_course.addressed_to,
            programme_en: my_course.programme,
            programme_ca: my_course.programme,
            programme_es: my_course.programme,
            professorship_en: my_course.professorship,
            professorship_ca: my_course.professorship,
            professorship_es: my_course.professorship,
            methodology_en: my_course.methodology,
            methodology_ca: my_course.methodology,
            methodology_es: my_course.methodology,
            seats_en: my_course.seats,
            seats_ca: my_course.seats,
            seats_es: my_course.seats,
            instructors_en: my_course.instructors,
            instructors_ca: my_course.instructors,
            instructors_es: my_course.instructors,
            slug: my_course.slug,
            hashtag: my_course.hashtag,
            hero_image: nil,
            banner_image: nil,
            promoted: my_course.promoted,
            scopes_enabled: my_course.scopes_enabled,
            scope: my_course.scope,
            area: my_course.area,
            show_statistics: my_course.show_statistics,
            duration: my_course.duration,
            address: my_course.address,
            start_date: my_course.start_date,
            end_date: my_course.end_date,
            schedule: my_course.schedule,
            modality: my_course.modality,
            registration_link: my_course.registration_link
          }
        }
      end
      let(:context) do
        {
          current_organization: my_course.organization,
          current_user: user,
          course_id: my_course.id
        }
      end
      let(:form) do
        Admin::CourseForm.from_params(params).with_context(context)
      end
      let(:command) { described_class.new(my_course, form) }

      describe "when the form is valid" do
        it "sets the area for the current department admin" do
          expect { command.call }.to broadcast(:ok)
          my_course.reload

          expect(my_course.area).to eq(area)
        end
      end
    end
  end
end
