# frozen_string_literal: true

require "spec_helper"

describe Decidim::Courses::CoursePresenter, type: :helper do
  subject { described_class.new(course) }

  let!(:course) { create :course }

  before do
    helper.extend(Decidim::ApplicationHelper)
    helper.extend(Decidim::TranslationsHelper)
  end

  describe "when asking for image urls" do
    context "when the hero_image_url is found" do
      let(:hero_image_url) { URI.join(decidim.root_url(host: course.organization.host), course.hero_image_url).to_s }

      it "shows the course hero_image_url" do
        expect(subject.hero_image_url).to eq hero_image_url
      end
    end

    context "when the banner_image_url is found" do
      let(:banner_image_url) { URI.join(decidim.root_url(host: course.organization.host), course.banner_image_url).to_s }

      it "shows the course banner_image_url" do
        expect(subject.banner_image_url).to eq banner_image_url
      end
    end
  end
end
