# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_courses do |t|
      t.string :hashtag
      t.string :hero_image
      t.string :banner_image
      t.boolean :promoted, default: false
      t.boolean :show_statistics, default: false
      t.integer :decidim_organization_id,
                foreign_key: true,
                index: { name: "index_decidim_courses_on_decidim_organization_id" }

      t.jsonb :title, null: false
      t.jsonb :description, null: false
      t.string :slug, null: false
      t.datetime :course_date
      t.integer :duration
      t.jsonb :instructors
      t.string :modality, null: false
      t.boolean :scopes_enabled, null: false, default: true
      t.integer :decidim_scope_id
      t.text :registration_link
      t.text :address
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :published_at

      t.index [:decidim_organization_id, :slug],
              name: "index_unique_course_slug_and_organization",
              unique: true
    end
  end
end
