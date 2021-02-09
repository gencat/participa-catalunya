# frozen_string_literal: true

require "rails_helper"

module Decidim::ResourceBanks
  describe Admin::CreateResourceBank do
    subject { described_class.new(form) }

    let(:organization) { create :organization }
    let(:current_user) { create :department_admin, :confirmed, organization: organization, area: area }
    let(:scope) { create :scope, organization: organization }
    let(:area) { create :area, organization: organization }

    let(:form) do
      Admin::ResourceBankForm
        .from_params(
          announcement: { en: "title" },
          title: { en: "title" },
          text: { en: "description" },
          slug: "slug",
          hashtag: "hashtag",
          hero_image: nil,
          banner_image: nil,
          promoted: nil,
          scopes_enabled: true,
          scope: scope,
          area: nil,
          show_statistics: false,
          authorship: Faker::Name.name,
          video_url: Faker::Internet.url
        )
        .with_context(
          current_user: current_user,
          current_organization: organization
        )
    end
    let(:invalid) { false }

    context "when everything is ok" do
      let(:resource_bank) { Decidim::ResourceBank.last }

      it "creates a resource bank with the user area" do
        subject.call

        expect(resource_bank.area).to eq area
      end
    end
  end
end
