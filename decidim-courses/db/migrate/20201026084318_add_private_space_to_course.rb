class AddPrivateSpaceToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_courses, :private_space, :boolean, default: false
  end
end
