# frozen_string_literal: true

require "spec_helper"

describe "Course registrations", type: :system do
  let(:organization) { create :organization }
  let(:courses_count) { 5 }
  let!(:courses) do
    create_list(:course, courses_count, organization: organization)
  end
  let(:course) { courses.first }
  let!(:user) { create :user, :confirmed, organization: organization }

  let(:registrations_enabled) { true }
  let(:available_slots) { 20 }
  let(:registration_terms) do
    {
      en: "A legal text",
      es: "Un texto legal",
      ca: "Un text legal"
    }
  end
  let(:registration_types_count) { 5 }
  let!(:registration_types) do
    create_list(:registration_type, registration_types_count, course: course)
  end
  let(:registration_type) { registration_types.first }

  def visit_course
    visit decidim_courses.course_path(course)
  end

  def visit_course_registration_types
    visit decidim_courses.course_registration_types_path(course)
  end

  before do
    switch_to_host(organization.host)

    course.update!(
      registrations_enabled: registrations_enabled,
      available_slots: available_slots,
      registration_terms: registration_terms
    )
  end

  context "when course registrations are not enabled" do
    let(:registrations_enabled) { false }

    it "the registration button is not visible" do
      visit_course

      within ".hero__container" do
        expect(page).not_to have_button("REGISTER")
      end
    end
  end

  context "when course registrations are enabled" do
    context "and the course has not a slot available" do
      let(:available_slots) { 1 }

      before do
        create(:course_registration, course: course, user: user, registration_type: registration_type)
      end

      it "the registration button is disabled" do
        visit_course_registration_types

        expect(page).to have_css(".course-registration", count: registration_types_count)

        within ".wrapper" do
          expect(page).to have_css("button[disabled]", text: "NO SLOTS AVAILABLE", count: 5)
        end
      end
    end

    context "and the course has a slot available" do
      context "and the user is not logged in" do
        it "they have the option to sign in" do
          visit_course_registration_types

          within ".wrapper" do
            first(:button, "Registration").click
          end

          expect(page).to have_css("#loginModal", visible: :visible)
        end
      end
    end

    context "and the user is logged in" do
      before do
        login_as user, scope: :user
      end

      it "they can join the course" do
        visit_course_registration_types

        within "#registration-type-#{registration_type.id}" do
          click_button "Registration"
        end

        within "#course-registration-confirm-#{registration_type.id}" do
          expect(page).to have_content "A legal text"
          page.find(".button.expanded").click
        end

        expect(page).to have_content("successfully")

        within ".wrapper" do
          expect(page).to have_css(".button", text: "ATTENDING")
          expect(page).to have_css("button[disabled]", text: "REGISTRATION", count: 4)
        end
      end
    end
  end

  context "and the user is going to the course" do
    before do
      create(:course_registration, course: course, user: user, registration_type: registration_type)
      login_as user, scope: :user
    end

    it "they can leave the course" do
      visit_course_registration_types

      within "#registration-type-#{registration_type.id}" do
        click_button "Attending"
      end

      expect(page).to have_content("successfully")

      within ".wrapper" do
        expect(page).to have_css(".button", text: "REGISTRATION", count: registration_types_count)
      end
    end
  end
end
