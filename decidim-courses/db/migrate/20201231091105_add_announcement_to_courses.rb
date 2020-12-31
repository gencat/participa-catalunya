# frozen_string_literal: true

class AddAnnouncementToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_courses, :announcement, :jsonb
  end
end
