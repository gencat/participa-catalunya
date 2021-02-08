# frozen_string_literal: true

require "rails_helper"

module Decidim::ResourceBanks
  describe Admin::UpdateResourceBank do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:my_resource_bank) { create :resource_bank, organization: organization }
      let(:area) { create(:area, organization: organization) }
      let(:user) { create :department_admin, :confirmed, organization: my_resource_bank.organization, area: area }

      let(:params) do
        {
          resource_bank: {
            id: my_resource_bank.id,
            current_organization: my_resource_bank.organization,
            errors: my_resource_bank.errors,
            announcement_en: "Announcement en",
            announcement_ca: "Announcement ca",
            announcement_es: "Announcement es",
            title_en: "Title en",
            title_ca: "Title ca",
            title_es: "Title es",
            text_en: my_resource_bank.text,
            text_ca: my_resource_bank.text,
            text_es: my_resource_bank.text,
            slug: my_resource_bank.slug,
            hashtag: my_resource_bank.hashtag,
            hero_image: nil,
            banner_image: nil,
            promoted: my_resource_bank.promoted,
            scopes_enabled: my_resource_bank.scopes_enabled,
            scope: my_resource_bank.scope,
            area: my_resource_bank.area,
            show_statistics: my_resource_bank.show_statistics,
            authorship: my_resource_bank.authorship,
            video_url: my_resource_bank.video_url
          }
        }
      end
      let(:context) do
        {
          current_organization: my_resource_bank.organization,
          current_user: user,
          resource_bank_id: my_resource_bank.id
        }
      end
      let(:form) do
        Admin::ResourceBankForm.from_params(params).with_context(context)
      end
      let(:command) { described_class.new(my_resource_bank, form) }

      describe "when the form is valid" do
        it "sets the area for the current department admin" do
          expect { command.call }.to broadcast(:ok)
          my_resource_bank.reload

          expect(my_resource_bank.area).to eq(area)
        end
      end
    end
  end
end
