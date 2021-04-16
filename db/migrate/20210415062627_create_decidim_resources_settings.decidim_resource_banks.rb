# frozen_string_literal: true
# This migration comes from decidim_resource_banks (originally 20210415061348)

class CreateDecidimResourcesSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_resources_settings do |t|
      t.references :decidim_scope, foreign_key: true
      t.references :decidim_organization, foreign_key: true
    end
  end
end
