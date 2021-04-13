# frozen_string_literal: true

class RemoveSeatsFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_courses, :seats
  end
end
