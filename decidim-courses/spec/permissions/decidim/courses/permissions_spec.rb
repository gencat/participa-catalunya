# frozen_string_literal: true

require "spec_helper"

describe Decidim::Courses::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { create :user, :admin, organization: organization }
  let(:organization) { create :organization }
  let(:course) { create :course, organization: organization }
  let(:context) { {} }
  let(:permission_action) { Decidim::PermissionAction.new(action) }
  let(:course_admin) { create :course_admin, course: course }

  shared_examples "access for role" do |access|
    if access == true
      it { is_expected.to eq true }
    elsif access == :not_set
      it_behaves_like "permission is not set"
    else
      it { is_expected.to eq false }
    end
  end

  shared_examples "access for roles" do |access|
    context "when user is org admin" do
      it_behaves_like "access for role", access[:org_admin]
    end

    context "when user is a space admin" do
      let(:user) { course_admin }

      it_behaves_like "access for role", access[:admin]
    end
  end

  context "when the action is for the public part" do
    context "when reading the admin dashboard" do
      let(:action) do
        { scope: :admin, action: :read, subject: :admin_dashboard }
      end

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true
      )
    end

    context "when reading a course" do
      let(:action) do
        { scope: :public, action: :read, subject: :course }
      end
      let(:context) { { course: course } }

      context "when the user is an admin" do
        let(:user) { create :user, :admin }

        it { is_expected.to eq true }
      end

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

  context "when the scope is not public" do
    let(:action) do
      { scope: :foo, action: :read, subject: :dummy_resource }
    end

    it_behaves_like "permission is not set"
  end

  context "when accessing the space area" do
    let(:action) do
      { scope: :admin, action: :enter, subject: :space_area }
    end
    let(:context) { { space_name: :courses } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true
    )
  end

  context "when reading the admin dashboard from the admin part" do
    let(:action) do
      { scope: :admin, action: :read, subject: :admin_dashboard }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true
    )
  end

  context "when reading the courses list" do
    let(:action) do
      { scope: :admin, action: :read, subject: :course_list }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true
    )
  end

  context "when reading a course" do
    let(:action) do
      { scope: :admin, action: :read, subject: :course }
    end
    let(:context) { { course: course } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true
    )
  end

  context "when reading a participatory_space" do
    let(:action) do
      { scope: :admin, action: :read, subject: :participatory_space }
    end
    let(:context) { { current_participatory_space: course } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true
    )
  end

  context "when creating a course" do
    let(:action) do
      { scope: :admin, action: :create, subject: :course }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: false
    )
  end

  context "with a course" do
    let(:context) { { course: course } }

    context "when publishing a course" do
      let(:action) do
        { scope: :admin, action: :publish, subject: :course }
      end

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true
      )
    end

    context "when user is a course admin" do
      let(:user) { course_admin }

      context "when creating a course" do
        let(:action) do
          { scope: :admin, action: :create, subject: :course }
        end

        it { is_expected.to eq false }
      end

      shared_examples "allows any action on subject" do |action_subject|
        context "when action subject is #{action_subject}" do
          let(:action) do
            { scope: :admin, action: :foo, subject: action_subject }
          end

          it { is_expected.to eq true }
        end
      end

      it_behaves_like "allows any action on subject", :attachment
      it_behaves_like "allows any action on subject", :attachment_collection
      it_behaves_like "allows any action on subject", :course
      it_behaves_like "allows any action on subject", :course_user_role
    end

    context "when user is an org admin" do
      context "when creating a course" do
        let(:action) do
          { scope: :admin, action: :create, subject: :course }
        end

        it { is_expected.to eq true }
      end

      shared_examples "allows any action on subject" do |action_subject|
        context "when action subject is #{action_subject}" do
          let(:action) do
            { scope: :admin, action: :foo, subject: action_subject }
          end

          it { is_expected.to eq true }
        end
      end

      it_behaves_like "allows any action on subject", :attachment
      it_behaves_like "allows any action on subject", :attachment_collection
      it_behaves_like "allows any action on subject", :course
      it_behaves_like "allows any action on subject", :course_user_role
    end
  end
end
