# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses::Admin
  describe CourseForm do
    subject { described_class.from_params(attributes).with_context(current_organization: organization) }

    let(:organization) { create :organization }

    let(:title) do
      {
        en: "Title",
        es: "Título",
        ca: "Títol"
      }
    end
    let(:description) do
      {
        en: "Description",
        es: "Descripción",
        ca: "Descripció"
      }
    end
    let(:instructors) do
      {
        en: "Instructors",
        es: "Instructores",
        ca: "Instructors"
      }
    end
    let(:registration_terms) do
      {
        en: "Registrations terms",
        es: "Términos de registro",
        ca: "Termes de registre"
      }
    end
    let(:slug) { "slug" }
    let(:attachment) { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
    let(:show_statistics) { true }
    let(:duration) { "duration" }
    let(:start_date) { 2.days.from_now }
    let(:end_date) { 4.days.from_now }
    let(:schedule) { "schedule" }
    let(:modality) { Decidim::Course::MODALITIES.sample }
    let(:attributes) do
      {
        "course" => {
          "title_en" => title[:en],
          "title_es" => title[:es],
          "title_ca" => title[:ca],
          "description_en" => description[:en],
          "description_es" => description[:es],
          "description_ca" => description[:ca],
          "instructors_en" => instructors[:en],
          "instructors_es" => instructors[:es],
          "instructors_ca" => instructors[:ca],
          "hashtag" => "hashtag",
          "hero_image" => attachment,
          "banner_image" => attachment,
          "promoted" => true,
          "slug" => slug,
          "show_statistics" => show_statistics,
          "duration" => duration,
          "start_date" => start_date,
          "end_date" => end_date,
          "schedule" => schedule,
          "modality" => modality,
          "address" => "address",
          "registrations_enabled" => true,
          "available_slots" => 0,
          "registration_terms_en" => registration_terms[:en],
          "registration_terms_es" => registration_terms[:es],
          "registration_terms_ca" => registration_terms[:ca],
          "registration_link" => Faker::Internet.url
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
        organization.settings.tap do |settings|
          settings.upload.maximum_file_size.default = 5
        end
        expect(subject.hero_image).to receive(:size).twice.and_return(6.megabytes)
      end

      it { is_expected.not_to be_valid }
    end

    context "when banner_image is too big" do
      before do
        organization.settings.tap do |settings|
          settings.upload.maximum_file_size.default = 5
        end
        expect(subject.banner_image).to receive(:size).twice.and_return(6.megabytes)
      end

      it { is_expected.not_to be_valid }
    end

    context "when images are not the expected type" do
      let(:attachment) { Decidim::Dev.test_file("Exampledocument.pdf", "application/pdf") }

      it { is_expected.not_to be_valid }
    end

    context "when registration_terms is missing" do
      let(:registration_terms) do
        {
          ca: "Registration terms"
        }
      end

      it { is_expected.to be_invalid }
    end

    context "when default language in title is missing" do
      let(:title) do
        {
          ca: "Títol"
        }
      end

      it { is_expected.to be_invalid }
    end

    context "when default language in description is missing" do
      let(:description) do
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
          create(:course, slug: slug, organization: organization)
        end

        it "is not valid" do
          expect(subject).not_to be_valid
          expect(subject.errors[:slug]).not_to be_empty
        end
      end

      context "when in another organization" do
        before do
          create(:course, slug: slug)
        end

        it "is valid" do
          expect(subject).to be_valid
        end
      end
    end
  end
end
