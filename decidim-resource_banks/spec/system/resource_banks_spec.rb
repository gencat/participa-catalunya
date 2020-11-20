# frozen_string_literal: true

require 'spec_helper'
require 'decidim/core/test/shared_examples/has_contextual_help'

describe 'Resource Banks', type: :system do
  let(:organization) { create(:organization) }
  let(:show_statistics) { false }
  let(:hashtag) { true }
  let(:base_resource_bank) do
    create(
      :resource_bank,
      organization: organization,
      text: { en: 'Text', ca: 'Text', es: 'Texto' },
      show_statistics: show_statistics
    )
  end

  before do
    switch_to_host(organization.host)
  end

  context 'when going to the resource_bank page' do
    let!(:resource_bank) { base_resource_bank }

    it_behaves_like 'editable content for admins' do
      let(:target_path) { decidim_resource_banks.resource_bank_path(resource_bank) }
    end

    context 'when requesting the resource_banks path' do
      before do
        visit decidim_resource_banks.resource_bank_path(resource_bank)
      end

      context 'when requesting the resource_bank path' do
        it 'shows the details of the given resource_bank' do
          within 'main' do
            expect(page).to have_content(translated(resource_bank.title, locale: :en))
            expect(page).to have_content(translated(resource_bank.text, locale: :en))
            expect(page).to have_content(resource_bank.video_url)
            expect(page).to have_content(translated(resource_bank.authorship, locale: :en))
          end
        end

        it_behaves_like 'has attachments' do
          let(:attached_to) { resource_bank }
        end

        it_behaves_like 'has attachment collections' do
          let(:attached_to) { resource_bank }
          let(:collection_for) { resource_bank }
        end
      end
    end
  end
end