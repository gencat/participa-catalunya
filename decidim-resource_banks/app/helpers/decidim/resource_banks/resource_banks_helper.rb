# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # Helpers related to the ResourceBanks layout.
    module ResourceBanksHelper
      include Decidim::ResourceHelper
      include Decidim::AttachmentsHelper
      include Decidim::IconHelper
      include Decidim::SanitizeHelper
      include Decidim::ResourceReferenceHelper
      include Decidim::FiltersHelper
    end
  end
end
