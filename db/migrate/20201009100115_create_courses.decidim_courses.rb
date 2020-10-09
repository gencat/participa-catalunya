# This migration comes from decidim_courses (originally 20201009085507)
class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.jsonb :title, null: false
      t.jsonb :description, null: false
      t.string :slug, null: false
      t.datetime :course_date
      t.integer :duration
      t.jsonb :instructors
      t.string :modality, null: false
      t.integer :decidim_scope_id
      t.text :registration_link
      t.text :address
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :published_at
    end
  end
end
