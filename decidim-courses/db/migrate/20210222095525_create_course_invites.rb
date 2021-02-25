# frozen_string_literal: true

class CreateCourseInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_courses_course_invites do |t|
      t.references :decidim_user, null: false, index: true
      t.references :decidim_course, null: false,
                                        index: { name: "idx_decidim_courses_invites_on_course_id" }
      t.datetime :sent_at
      t.datetime :accepted_at
      t.datetime :rejected_at

      t.timestamps
    end
  end
end
