# This migration comes from decidim_courses (originally 20201231091105)
class AddAnnouncementToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_courses, :announcement, :jsonb
  end
end
