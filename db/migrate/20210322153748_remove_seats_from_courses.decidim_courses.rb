# frozen_string_literal: true
# This migration comes from decidim_courses (originally 20210322163526)

class RemoveSeatsFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_courses, :seats
  end
end
