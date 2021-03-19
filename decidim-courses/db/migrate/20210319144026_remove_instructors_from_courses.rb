class RemoveInstructorsFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_courses, :instructors
  end
end
