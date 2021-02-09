# frozen_string_literal: true

require "rails_helper"

describe Decidim::Courses::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { create :department_admin, organization: organization, area: area }
  let(:organization) { create :organization }
  let(:course) { create :course, organization: organization }
  let(:context) { {} }
  let(:permission_action) { Decidim::PermissionAction.new(action) }
  let(:area) { create(:area, organization: organization) }

  shared_examples "access for role" do |access|
    if access == true
      it { is_expected.to eq true }
    elsif access == :not_set
      it_behaves_like "permission is not set"
    else
      it { is_expected.to eq false }
    end
  end

  shared_examples "verifies action on subject" do |action_subject, access|
    context "when action subject is #{action_subject}" do
      let(:action) do
        { scope: :admin, action: :foo, subject: action_subject }
      end

      it { is_expected.to eq access }
    end
  end

  context "when the action is for the public part" do
    context "when reading the admin dashboard" do
      let(:action) do
        { scope: :admin, action: :read, subject: :admin_dashboard }
      end

      it_behaves_like "access for role", true
    end

    context "when reading a course" do
      let(:action) do
        { scope: :public, action: :read, subject: :course }
      end
      let(:context) { { course: course } }

      context "when the course is published" do
        let(:user) { create :user, organization: organization }

        it { is_expected.to eq true }
      end

      context "when the course is not published" do
        let(:user) { create :user, organization: organization }
        let(:course) { create :course, :unpublished, organization: organization }

        context "when the user doesn't have access to it" do
          it { is_expected.to eq false }
        end

        context "when the user has access to it" do
          before do
            create :course_user_role, user: user, course: course
          end

          it { is_expected.to eq true }
        end
      end
    end

    context "when listing courses" do
      let(:action) do
        { scope: :public, action: :list, subject: :course }
      end

      it { is_expected.to eq true }
    end

    context "when reporting a resource" do
      let(:action) do
        { scope: :public, action: :create, subject: :moderation }
      end

      it { is_expected.to eq true }
    end

    context "when any other action" do
      let(:action) do
        { scope: :public, action: :foo, subject: :bar }
      end

      it_behaves_like "permission is not set"
    end
  end

  context "when no user is given" do
    let(:user) { nil }
    let(:action) do
      { scope: :admin, action: :read, subject: :dummy_resource }
    end

    it_behaves_like "permission is not set"
  end

  context "when accessing the space area" do
    let(:action) do
      { scope: :admin, action: :enter, subject: :space_area }
    end
    let(:context) { { space_name: :courses } }

    it_behaves_like "access for role", true
  end

  context "when reading the admin dashboard from the admin part" do
    let(:action) do
      { scope: :admin, action: :read, subject: :admin_dashboard }
    end

    it_behaves_like "access for role", true
  end

  context "when reading the courses list" do
    let(:action) do
      { scope: :admin, action: :read, subject: :course_list }
    end

    it_behaves_like "access for role", true
  end

  context "when exporting the courses list" do
    let(:action) do
      { scope: :admin, action: :export, subject: :courses }
    end

    it_behaves_like "access for role", false
  end

  context "when reading a course" do
    let(:action) do
      { scope: :admin, action: :read, subject: :course }
    end
    let(:context) { { course: course } }

    it_behaves_like "access for role", false

    context "when the department admin is in the same area" do
      before do
        course.update!(area: area)
      end

      it { is_expected.to eq true }
    end
  end

  context "when reading a participatory_space" do
    let(:action) do
      { scope: :admin, action: :read, subject: :participatory_space }
    end
    let(:context) { { current_participatory_space: course } }

    it_behaves_like "access for role", true
  end

  context "when creating a course" do
    let(:action) do
      { scope: :admin, action: :create, subject: :course }
    end

    it_behaves_like "access for role", true
  end

  context "when exporting a course" do
    let(:action) do
      { scope: :admin, action: :export, subject: :course }
    end

    it_behaves_like "access for role", false

    context "when the department admin is in the same area" do
      before do
        course.update!(area: area)
      end

      it { is_expected.to eq true }
    end
  end

  context "with a course" do
    let(:context) { { course: course } }

    context "when publishing a course" do
      let(:action) do
        { scope: :admin, action: :publish, subject: :course }
      end

      it_behaves_like "access for role", false

      context "when the department admin is in the same area" do
        before do
          course.update!(area: area)
        end

        it { is_expected.to eq true }
      end
    end

    context "when creating a course" do
      let(:action) do
        { scope: :admin, action: :create, subject: :course }
      end

      it { is_expected.to eq true }
    end

    context "when doing an action on course" do
      it_behaves_like "verifies action on subject", :attachment, false
      it_behaves_like "verifies action on subject", :attachment_collection, false
      it_behaves_like "verifies action on subject", :course, false
      it_behaves_like "verifies action on subject", :course_user_role, false

      context "when the department admin is in the same area" do
        before do
          course.update!(area: area)
        end

        it_behaves_like "verifies action on subject", :attachment, true
        it_behaves_like "verifies action on subject", :attachment_collection, true
        it_behaves_like "verifies action on subject", :course, true
        it_behaves_like "verifies action on subject", :course_user_role, true
      end
    end
  end
end
