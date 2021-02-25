# frozen_string_literal: true

class CreateCourseRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_courses_course_registrations do |t|
      t.references :decidim_user, null: false, index: { name: "index_decidim_courses_registrations_on_decidim_user_id" }
      t.references :decidim_course, null: false, index: { name: "index_courses_registrations_on_decidim_course" }

      t.timestamps
      t.integer "decidim_course_registration_type_id"
      t.datetime "confirmed_at"
    end

    add_index :decidim_courses_course_registrations,
              [:decidim_user_id, :decidim_course_id],
              unique: true,
              name: "decidim_courses_registrations_user_course_unique"

    add_index :decidim_courses_course_registrations,
              :decidim_course_registration_type_id,
              name: "idx_courses_registrations_on_registration_type_id"
  end
end
