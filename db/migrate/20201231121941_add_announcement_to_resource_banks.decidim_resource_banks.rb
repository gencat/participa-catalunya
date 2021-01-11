# This migration comes from decidim_resource_banks (originally 20201231121903)
class AddAnnouncementToResourceBanks < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_resource_banks, :announcement, :jsonb
  end
end
