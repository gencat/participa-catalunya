# frozen_string_literal: true

require "spec_helper"
require "decidim/core/test/shared_examples/space_cell_changes_button_text_cta"

module Decidim::Courses
  describe CourseMCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/courses/course_m", model).call }

    let(:model) { create(:course, :published) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(subject).to have_css(".card--course")
      end

      it "shows the course modality" do
        expect(subject).to have_content(t(model.modality, scope: "decidim.courses.modality"))
      end

      it "shows the course dates" do
        within "card__course-date" do
          expect(subject).to have_content(I18n.l(model.start_date.to_date, format: :decidim_short_with_month_name_short))
          expect(subject).to have_content(I18n.l(model.end_date.to_date, format: :decidim_short_with_month_name_short))
        end
      end

      context "when course does not spans multiple days" do
        before do
          model.end_date = model.start_date
        end

        it "renders only one date" do
          within ".card__course-date" do
            expect(subject).to have_content(I18n.l(model.start_date.to_date, format: :decidim_short_with_month_name_short), count: 1)
            expect(subject).not_to have_content("-")
          end
        end
      end
    end
  end
end
