# This migration comes from decidim_resource_banks (originally 20201230123121)
class AddScopeToResourceBanks < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_resource_banks do |t|
      t.boolean :scopes_enabled, null: false, default: true
      t.integer :decidim_scope_id,
                foreign_key: true,
                index: { name: "index_decidim_resource_banks_on_decidim_scope_id" }
    end
  end
end
