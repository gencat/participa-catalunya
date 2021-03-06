# frozen_string_literal: true
# This migration comes from decidim_department_admin (originally 20210420143021)

if defined?(Decidim::Conferences)
  class AddAreaToConferences < ActiveRecord::Migration[5.2]
    def change
      add_reference :decidim_conferences, :decidim_area, index: true
    end
  end
end
