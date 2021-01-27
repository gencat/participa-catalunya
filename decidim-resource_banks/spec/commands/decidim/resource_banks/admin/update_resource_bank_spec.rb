# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks
  describe Admin::UpdateResourceBank do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:my_resource_bank) { create :resource_bank, organization: organization }
      let(:user) { create :user, :admin, :confirmed, organization: my_resource_bank.organization }

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

      describe "when the form is not valid" do
        before do
          expect(form).to receive(:invalid?).and_return(true)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "doesn't update the resource_bank" do
          command.call
          my_resource_bank.reload

          expect(my_resource_bank.title["en"]).not_to eq("Title en")
        end
      end

      describe "when the resource_bank is not valid" do
        before do
          expect(form).to receive(:invalid?).and_return(false)
          expect(my_resource_bank).to receive(:valid?).at_least(:once).and_return(false)
          my_resource_bank.errors.add(:hero_image, "Image too big")
          my_resource_bank.errors.add(:banner_image, "Image too big")
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "adds errors to the form" do
          command.call

          expect(form.errors[:hero_image]).not_to be_empty
          expect(form.errors[:banner_image]).not_to be_empty
        end
      end

      describe "when the form is valid" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "updates the resource_bank" do
          expect { command.call }.to broadcast(:ok)
          my_resource_bank.reload

          expect(my_resource_bank.title["en"]).to eq("Title en")
        end

        it "traces the action", versioning: true do
          expect(Decidim.traceability)
            .to receive(:perform_action!)
            .with(:update, my_resource_bank, user)
            .and_call_original

          expect { command.call }.to change(Decidim::ActionLog, :count)
          action_log = Decidim::ActionLog.last
          expect(action_log.version).to be_present
        end

        context "when no homepage image is set" do
          it "does not replace the homepage image" do
            command.call
            my_resource_bank.reload

            expect(my_resource_bank.hero_image).to be_present
          end
        end

        context "when no banner image is set" do
          it "does not replace the banner image" do
            command.call
            my_resource_bank.reload

            expect(my_resource_bank.banner_image).to be_present
          end
        end
      end
    end
  end
end
