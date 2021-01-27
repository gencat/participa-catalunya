# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe "Courses Participatory Space" do
    let(:command) { Decidim::DestroyAccount.new(user, form) }

    let(:user) { create(:user, :confirmed) }
    let(:valid) { true }
    let(:data) do
      {
        delete_reason: "I want to delete my account"
      }
    end

    let(:form) do
      form = double(
        delete_reason: data[:delete_reason],
        valid?: valid
      )

      form
    end

    context "when an account is removed" do
      it "deletes course user role" do
        create(:course_user_role, user: user)

        expect do
          command.call
        end.to change(CourseUserRole, :count).by(-1)
      end
    end
  end
end
