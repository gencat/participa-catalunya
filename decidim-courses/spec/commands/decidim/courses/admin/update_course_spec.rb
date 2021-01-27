# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe Admin::UpdateCourse do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:my_course) { create :course, organization: organization }
      let(:user) { create :user, :admin, :confirmed, organization: my_course.organization }

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

      describe "when the form is not valid" do
        before do
          expect(form).to receive(:invalid?).and_return(true)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "doesn't update the course" do
          command.call
          my_course.reload

          expect(my_course.title["en"]).not_to eq("Title en")
        end
      end

      describe "when the course is not valid" do
        before do
          expect(form).to receive(:invalid?).and_return(false)
          expect(my_course).to receive(:valid?).at_least(:once).and_return(false)
          my_course.errors.add(:hero_image, "Image too big")
          my_course.errors.add(:banner_image, "Image too big")
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "adds errors to the form" do
          command.call

          expect(form.errors[:hero_image]).not_to be_empty
          expect(form.errors[:banner_image]).not_to be_empty
        end
      end

      describe "when the form is valid" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "updates the course" do
          expect { command.call }.to broadcast(:ok)
          my_course.reload

          expect(my_course.title["en"]).to eq("Title en")
        end

        it "traces the action", versioning: true do
          expect(Decidim.traceability)
            .to receive(:perform_action!)
            .with(:update, my_course, user)
            .and_call_original

          expect { command.call }.to change(Decidim::ActionLog, :count)
          action_log = Decidim::ActionLog.last
          expect(action_log.version).to be_present
        end

        context "when no homepage image is set" do
          it "does not replace the homepage image" do
            command.call
            my_course.reload

            expect(my_course.hero_image).to be_present
          end
        end

        context "when no banner image is set" do
          it "does not replace the banner image" do
            command.call
            my_course.reload

            expect(my_course.banner_image).to be_present
          end
        end
      end
    end
  end
end
