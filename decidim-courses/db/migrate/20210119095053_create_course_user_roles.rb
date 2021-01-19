# frozen_string_literal: true

class CreateCourseUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_course_user_roles do |t|
      t.integer :decidim_user_id
      t.integer :decidim_course_id
      t.string :role
      t.timestamps
    end

    add_index :decidim_course_user_roles,
              [:decidim_course_id, :decidim_user_id, :role],
              unique: true,
              name: "index_unique_user_and_course_role"

    add_index :decidim_course_user_roles, :decidim_user_id
  end
end
