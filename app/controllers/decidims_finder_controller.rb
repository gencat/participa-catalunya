# frozen_string_literal: true

class DecidimsFinderController < Decidim::ApplicationController
  layout "layouts/decidim/application"

  helper_method :current_translations

  def show; end

  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale].with_indifferent_access
  end
end
