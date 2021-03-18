# frozen_string_literal: true

module Decidim
  module Courses
    # This cell renders the media link card for an instance of a RegistrationType
    class RegistrationTypeCell < Decidim::ViewModel
      include ActionView::Helpers::NumberHelper
      include Decidim::SanitizeHelper
      include Decidim::Courses::Engine.routes.url_helpers
      include Decidim::LayoutHelper

      def show
        render
      end

      private

      delegate :current_user, to: :controller, prefix: false

      def title
        translated_attribute model.title
      end

      def description
        translated_attribute model.description
      end

      def allowed?
        options[:allowed]
      end

      def button_classes
        "button button--sc small"
      end

      def course
        model.course
      end

      def i18n_join_text
        I18n.t("registration", scope: "decidim.courses.course.show")
      end
    end
  end
end
