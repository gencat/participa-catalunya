# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe Admin::CreateResourceBank do
    subject { described_class.new(form) }

    let(:organization) { create :organization }
    let(:current_user) { create :user, :admin, :confirmed, organization: organization }
    let(:scope) { create :scope, organization: organization }
    let(:area) { create :area, organization: organization }
    let(:errors) { double.as_null_object }

    let(:form) do
      instance_double(
        Admin::ResourceBankForm,
        current_user: current_user,
        current_organization: organization,
        invalid?: invalid,
        errors: errors,

        title: { en: "title" },
        text: { en: "description" },
        slug: "slug",
        hashtag: "hashtag",
        hero_image: nil,
        banner_image: nil,
        promoted: nil,
        scopes_enabled: true,
        scope: scope,
        area: area,
        show_statistics: false,
        authorship: Faker::Name.name,
        video_url: Faker::Internet.url
      )
    end
    let(:invalid) { false }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the resource_bank is not persisted" do
      let(:invalid_resource_bank) do
        instance_double(
          Decidim::ResourceBank,
          persisted?: false,
          valid?: false,
          errors: {
            hero_image: "Image too big",
            banner_image: "Image too big"
          }
        ).as_null_object
      end

      before do
        allow(Decidim::ActionLogger).to receive(:log).and_return(true)
        expect(Decidim::ResourceBank).to receive(:create).and_return(invalid_resource_bank)
      end

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end

      it "adds errors to the form" do
        expect(errors).to receive(:add).with(:hero_image, "Image too big")
        expect(errors).to receive(:add).with(:banner_image, "Image too big")
        subject.call
      end
    end

    context "when everything is ok" do
      let(:resource_bank) { Decidim::ResourceBank.last }

      it "creates a resource_bank" do
        expect { subject.call }.to change { Decidim::ResourceBank.count }.by(1)
      end

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:create)
          .with(Decidim::ResourceBank, current_user, kind_of(Hash))
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
