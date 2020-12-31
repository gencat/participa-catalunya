# frozen_string_literal: true

class AddAnnouncementToResourceBanks < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_resource_banks, :announcement, :jsonb
  end
end
