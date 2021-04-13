# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Courses
    module Admin
      describe CoursesSettingsController, type: :controller do
        routes { Decidim::Courses::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let(:current_user) { create(:user, :confirmed, :admin, organization: organization) }
        let(:scope) { create(:user, organization: organization) }
        let(:params) do
          {
            decidim_scope_id: scope.id
          }
        end

        before do
          request.env["decidim.current_organization"] = organization
          sign_in current_user
        end

        describe "when no settings were previously defined" do
          it "creates new courses settings" do
            post(:update, params: params)
            expect(flash[:alert]).to be_present
            expect(flash[:notice]).not_to be_present
          end
        end

        describe "when courses settings were already setted" do
          before do
            old_scope = create(:scope, organization: organization)
            Decidim::CoursesSetting.create(organization: organization, scope: old_scope)
          end

          it "updates courses settings" do
            post(:update, params: params)
            expect(flash[:alert]).to be_present
            expect(flash[:notice]).not_to be_present
          end
        end
      end
    end
  end
end
