# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe Admin::UnpublishResourceBank do
    subject { described_class.new(my_resource_bank, user) }

    let(:my_resource_bank) { create :resource_bank, :published, organization: user.organization }
    let(:user) { create :user }

    context "when the resource_bank is nil" do
      let(:my_resource_bank) { nil }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the resource_bank is not published" do
      let(:my_resource_bank) { create :resource_bank, :unpublished }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the resource_bank is published" do
      it "is valid" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "unpublishes it" do
        subject.call
        my_resource_bank.reload
        expect(my_resource_bank).not_to be_published
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with("unpublish", my_resource_bank, user)
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)

        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
        expect(action_log.version.event).to eq "update"
      end
    end
  end
end
