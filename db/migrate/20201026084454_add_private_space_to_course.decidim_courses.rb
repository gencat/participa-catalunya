# This migration comes from decidim_courses (originally 20201026084318)
class AddPrivateSpaceToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_courses, :private_space, :boolean, default: false
  end
end
