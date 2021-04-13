# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe Admin::CreateRegistrationType do
    subject { described_class.new(form, current_user, course) }

    let(:course) { create(:course) }
    let(:user) { nil }
    let!(:current_user) { create :user, :confirmed, organization: course.organization }

    let(:form) do
      double(
        Admin::RegistrationTypeForm,
        invalid?: invalid,
        current_user: current_user,
        title: { en: "title" },
        attributes: {
          title: { en: "title" },
          weight: 1,
          description: { en: "registration type description" }
        }
      )
    end

    let(:invalid) { false }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      let(:registration_type) { Decidim::Courses::RegistrationType.last }

      it "creates a registration type" do
        expect { subject.call }.to change { Decidim::Courses::RegistrationType.count }.by(1)
      end

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "sets the registration type" do
        subject.call
        expect(registration_type.course).to eq course
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with(:create, Decidim::Courses::RegistrationType, current_user, participatory_space: { title: course.title }, resource: { title: form.title })
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
