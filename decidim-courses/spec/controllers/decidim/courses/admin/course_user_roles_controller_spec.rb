# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    module Admin
      describe CourseUserRolesController, type: :controller do
        routes { Decidim::Courses::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let(:current_user) { create(:user, :confirmed, :admin, organization: organization) }
        let!(:course) do
          create(
            :course,
            :published,
            organization: organization
          )
        end

        before do
          request.env["decidim.current_organization"] = organization
          request.env["decidim.current_course"] = course
          sign_in current_user
        end

        describe "creates new course admin" do
          let(:new_course_admin_name) { "new course admin name" }
          let(:new_course_admin_email) { "course_admin@mail.com" }
          let(:new_course_admin_params) do
            {
              course_user_role: {
                name: new_course_admin_name,
                email: new_course_admin_email,
                role: "admin"
              },
              course_slug: course.slug
            }
          end

          describe "with a valid nickname" do
            it "create new admin successfully" do
              post(:create, params: new_course_admin_params)
              expect(response).to redirect_to(course_user_roles_path(course.slug))
              expect(flash[:notice]).to be_present
              expect(flash[:alert]).not_to be_present
            end
          end

          describe "with an invalid nickname" do
            let(:new_course_admin_name) { "new course (admin) name" }

            it "must detect invalid nickname chars" do
              post(:create, params: new_course_admin_params)
              expect(flash[:alert]).to be_present
              expect(flash[:notice]).not_to be_present
            end
          end
        end
      end
    end
  end
end
