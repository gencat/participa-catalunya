# frozen_string_literal: true

# This migration comes from decidim (originally 20180221101934)

class UpdateLiterals < ActiveRecord::Migration[5.1]
  class TermCustomizerTranslations < ApplicationRecord
    self.table_name = :decidim_term_customizer_translations
  end
  class StaticPages < ApplicationRecord
    self.table_name = :decidim_static_pages
  end
  class StaticPageTopics < ApplicationRecord
    self.table_name = :decidim_static_page_topics
  end

  def change
    TermCustomizerTranslations.where(key: 'layouts.decidim.footer.download_open_data')
        .where(locale: 'oc')
        .update_all("value = 'Descarga de donades dubèrtes'")

    TermCustomizerTranslations.where(key: 'decidim.menu.assemblies')
        .where(locale: 'ca')
        .update_all("value = 'Com. de pràctica '")

    TermCustomizerTranslations.where(key: 'decidim.menu.assemblies')
        .where(locale: 'oc')
        .update_all("value = 'Com. de practica '")

    TermCustomizerTranslations.where(key: 'decidim.menu.assemblies')
        .where(locale: 'es')
        .update_all("value = 'Com. de práctica '")

    TermCustomizerTranslations.where(key: 'decidim.menu.assemblies')
        .where(locale: 'en')
        .update_all("value = 'Com. of practice'")

    StaticPages.where(slug: 'avis-legal')
        .update_all(title: {"ca" => "Avís legal", "en" => "Legal advisement", "es" => "Aviso legal", "oc" => "Avís legau"})

    StaticPages.where(slug: 'terms-and-conditions')
        .update_all(title: {"ca" => "Condicions d'ús", "en" => "Terms of use", "es" => "Condiciones de uso", "oc" => "Condicions d’usatge"})

    StaticPages.where(slug: 'accessibiltiat')
      .update_all(title: {"ca" => "Accessibilitat", "en" => "Accessibility", "es" => "Accesibilidad", "oc" => "Accessibilitat"})

    StaticPageTopics.where("title ->> 'ca' = ?", 'Preguntes freqüents')
      .update_all(title: {"ca" => "Preguntes freqüents", "en" => "General Help", "es" => "Ayuda general", "oc" => "Preguntes frequentes"})

    StaticPageTopics.where("title ->> 'ca' = ?", 'Participa Catalunya')
      .update_all(title: {"ca" => "Participa Catalunya", "en" => "Participa Catalonia", "es" => "Participa Cataluña", "oc" => "Participa Catalonha"})
  end
end
