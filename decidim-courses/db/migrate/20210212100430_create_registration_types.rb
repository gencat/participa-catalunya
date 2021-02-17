# frozen_string_literal: true

class CreateRegistrationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_courses_registration_types do |t|
      t.references :decidim_course, index: { name: "idx_registration_types_on_decidim_course_id" }
      t.jsonb :title, null: false
      t.jsonb :description, null: false
      t.decimal :price, null: false, default: 0, precision: 8, scale: 2
      t.integer :weight, null: false, default: 0
      t.datetime :published_at, index: true

      t.timestamps
    end
  end
end
