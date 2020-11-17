# frozen_string_literal: true

require "spec_helper"

module Decidim::ResourceBanks::Admin
  describe ResourceBankForm do
    subject { described_class.from_params(attributes).with_context(current_organization: organization) }

    let(:organization) { create :organization }

    let(:title) do
      {
        en: "Title",
        es: "Título",
        ca: "Títol"
      }
    end
    let(:text) do
      {
        en: "Description",
        es: "Descripción",
        ca: "Descripció"
      }
    end
    let(:slug) { "slug" }
    let(:attachment) { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
    let(:show_statistics) { true }
    let(:video_url) { Faker::Internet.url }
    let(:attributes) do
      {
        "resource_bank" => {
          "title_en" => title[:en],
          "title_es" => title[:es],
          "title_ca" => title[:ca],
          "text_en" => text[:en],
          "text_es" => text[:es],
          "text_ca" => text[:ca],
          "hashtag" => "hashtag",
          "hero_image" => attachment,
          "banner_image" => attachment,
          "promoted" => true,
          "slug" => slug,
          "show_statistics" => show_statistics,
          "authorship" => "authorship",
          "video_url" => Faker::Internet.url
        }
      }
    end

    before do
      Decidim::AttachmentUploader.enable_processing = true
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    context "when hero_image is too big" do
      before do
        allow(Decidim).to receive(:maximum_attachment_size).and_return(5.megabytes)
        expect(subject.hero_image).to receive(:size).twice.and_return(6.megabytes)
      end

      it { is_expected.not_to be_valid }
    end

    context "when banner_image is too big" do
      before do
        allow(Decidim).to receive(:maximum_attachment_size).and_return(5.megabytes)
        expect(subject.banner_image).to receive(:size).twice.and_return(6.megabytes)
      end

      it { is_expected.not_to be_valid }
    end

    context "when images are not the expected type" do
      let(:attachment) { Decidim::Dev.test_file("Exampledocument.pdf", "application/pdf") }

      it { is_expected.not_to be_valid }
    end

    context "when default language in title is missing" do
      let(:title) do
        {
          ca: "Títol"
        }
      end

      it { is_expected.to be_invalid }
    end

    context "when default language in text is missing" do
      let(:text) do
        {
          ca: "Descripció"
        }
      end

      it { is_expected.to be_invalid }
    end

    context "when slug is missing" do
      let(:slug) { nil }

      it { is_expected.to be_invalid }
    end

    context "when slug is not valid" do
      let(:slug) { "123" }

      it { is_expected.to be_invalid }
    end

    context "when slug is not unique" do
      context "when in the same organization" do
        before do
          create(:resource_bank, slug: slug, organization: organization)
        end

        it "is not valid" do
          expect(subject).not_to be_valid
          expect(subject.errors[:slug]).not_to be_empty
        end
      end

      context "when in another organization" do
        before do
          create(:resource_bank, slug: slug)
        end

        it "is valid" do
          expect(subject).to be_valid
        end
      end
    end
  end
end
