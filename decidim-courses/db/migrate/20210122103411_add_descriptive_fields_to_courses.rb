# frozen_string_literal: true

class AddDescriptiveFieldsToCourses < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_courses do |t|
      t.column :objectives, :jsonb
      t.column :addressed_to, :jsonb
      t.column :programme, :jsonb
      t.column :professorship, :jsonb
      t.column :methodology, :jsonb
      t.column :seats, :jsonb
    end
  end
end
