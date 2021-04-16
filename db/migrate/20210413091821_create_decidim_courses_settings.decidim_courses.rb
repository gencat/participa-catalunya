# This migration comes from decidim_courses (originally 20210413091623)
class CreateDecidimCoursesSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_courses_settings do |t|
      t.references :decidim_scope, foreign_key: true
      t.references :decidim_organization, foreign_key: true
    end
  end
end
