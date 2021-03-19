# frozen_string_literal: true

require "spec_helper"

describe Decidim::Courses::CoursePresenter, type: :helper do
  subject { described_class.new(course) }

  let!(:course) { create :course }
  let(:organization_host) { course.organization.host }

  describe "when images are stored in the local filesystem" do
    it "resolves hero_image_url" do
      expect(subject.hero_image_url).to eq("http://#{organization_host}#{course.hero_image_url}")
    end

    it "resolves banner_image_url" do
      expect(subject.banner_image_url).to eq("http://#{organization_host}#{course.banner_image_url}")
    end
  end

  describe "when images are stored in a cloud service" do
    it "resolves hero_image_url" do
      avoid_the_use_of_file_storage_specific_methods(:hero_image)
      expect(subject.hero_image_url).to eq("http://#{organization_host}#{course.hero_image_url}")
    end

    it "resolves banner_image_url" do
      avoid_the_use_of_file_storage_specific_methods(:banner_image)
      expect(subject.banner_image_url).to eq("http://#{organization_host}#{course.banner_image_url}")
    end

    def avoid_the_use_of_file_storage_specific_methods(uploader_name)
      # we're avoiding the use of `course.hero_image.file.file` in
      expect(course.send(uploader_name).file).not_to receive(:file)
    end
  end
end
