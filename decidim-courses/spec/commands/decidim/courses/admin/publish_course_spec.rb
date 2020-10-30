# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe Admin::PublishCourse do
    subject { described_class.new(my_course, user) }

    let(:my_course) { create :course, :unpublished, organization: user.organization }
    let(:user) { create :user }

    context "when the course is nil" do
      let(:my_course) { nil }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the course is published" do
      let(:my_course) { create :course }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the course is not published" do
      it "is valid" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "publishes it" do
        subject.call
        my_course.reload
        expect(my_course).to be_published
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with("publish", my_course, user, visibility: "all")
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)

        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
        expect(action_log.version.event).to eq "update"
      end
    end
  end
end
