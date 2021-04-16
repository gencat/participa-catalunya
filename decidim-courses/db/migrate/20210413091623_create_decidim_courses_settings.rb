# frozen_string_literal: true

class CreateDecidimCoursesSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_courses_settings do |t|
      t.references :decidim_scope, foreign_key: true
      t.references :decidim_organization, foreign_key: true
    end
  end
end
