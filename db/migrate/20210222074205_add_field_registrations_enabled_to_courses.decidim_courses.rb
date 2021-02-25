# frozen_string_literal: true
# This migration comes from decidim_courses (originally 20210222073841)

class AddFieldRegistrationsEnabledToCourses < ActiveRecord::Migration[5.2]  
  def change
    change_table :decidim_courses do |t|
      t.column :registrations_enabled, :boolean
    end
  end
end
