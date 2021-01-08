# frozen_string_literal: true

require "spec_helper"

module Decidim::Courses
  describe CourseSerializer do
    let(:resource) { create(:course) }
    let(:subject) { described_class.new(resource) }

    describe "#serialize" do
      it "includes the course data" do
        serialized = subject.serialize

        expect(serialized).to be_a(Hash)

        expect(serialized).to include(id: resource.id)
        expect(serialized).to include(slug: resource.slug)
        expect(serialized).to include(hashtag: resource.hashtag)
        expect(serialized).to include(decidim_organization_id: resource.decidim_organization_id)
        expect(serialized).to include(title: resource.title)
        expect(serialized).to include(description: resource.description)
        expect(serialized).to include(remote_hero_image_url: Decidim::Courses::CoursePresenter.new(resource).hero_image_url)
        expect(serialized).to include(remote_banner_image_url: Decidim::Courses::CoursePresenter.new(resource).banner_image_url)
        expect(serialized).to include(decidim_scope_id: resource.decidim_scope_id)
        expect(serialized).to include(show_statistics: resource.show_statistics)
        expect(serialized).to include(scopes_enabled: resource.scopes_enabled)
        expect(serialized).to include(duration: resource.duration)
        expect(serialized).to include(created_at: resource.created_at)
        expect(serialized).to include(start_date: resource.start_date)
        expect(serialized).to include(end_date: resource.end_date)
        expect(serialized).to include(address: resource.address)
        expect(serialized).to include(schedule: resource.schedule)
        expect(serialized).to include(registration_link: resource.registration_link)
        expect(serialized).to include(instructors: resource.instructors)
        expect(serialized).to include(modality: resource.modality)
      end

      context "when course has area" do
        let(:area) { create :area, organization: resource.organization }

        before do
          resource.area = area
          resource.save
        end

        it "includes the area" do
          serialized_area = subject.serialize[:area]

          expect(serialized_area).to be_a(Hash)

          expect(serialized_area).to include(id: resource.area.id)
          expect(serialized_area).to include(name: resource.area.name)
        end
      end

      context "when course has scope" do
        let(:scope) { create :scope, organization: resource.organization }

        before do
          resource.scope = scope
          resource.save
        end

        it "includes the scope" do
          serialized_scope = subject.serialize[:scope]

          expect(serialized_scope).to be_a(Hash)

          expect(serialized_scope).to include(id: resource.scope.id)
          expect(serialized_scope).to include(name: resource.scope.name)
        end
      end

      context "when course has attachments" do
        let!(:attachment_collection) { create(:attachment_collection, collection_for: resource) }
        let!(:attachment) { create(:attachment, attached_to: resource, attachment_collection: attachment_collection) }

        it "includes the attachment" do
          serialized_course_attachment = subject.serialize[:attachments][:files].first

          expect(serialized_course_attachment).to be_a(Hash)

          expect(serialized_course_attachment).to include(id: attachment.id)
          expect(serialized_course_attachment).to include(title: attachment.title)
          expect(serialized_course_attachment).to include(weight: attachment.weight)
          expect(serialized_course_attachment).to include(description: attachment.description)
          expect(serialized_course_attachment).to include(remote_file_url: Decidim::AttachmentPresenter.new(resource.attachments.first).attachment_file_url)
        end
      end
    end
  end
end
