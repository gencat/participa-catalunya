# frozen_string_literal: true

module Decidim
  module Courses
    # Helpers related to the Courses layout.
    module CoursesHelper
      include Decidim::ResourceHelper
      include Decidim::AttachmentsHelper
      include Decidim::IconHelper
      include Decidim::SanitizeHelper
      include Decidim::ResourceReferenceHelper
      include Decidim::FiltersHelper

      def modalities_select_field(form, name)
        modalities = Decidim::Course::MODALITIES.map { |m| [ I18n.t("modality.#{m}", scope: "decidim.courses"), m] }

        form.select(name,
                    modalities,
                    selected: form.object.send(name).presence,
                    include_blank: t("select_a_modality", scope: "decidim.courses.filters"),
                    label: false)
      end
    end
  end
end
