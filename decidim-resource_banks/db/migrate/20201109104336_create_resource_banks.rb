class CreateResourceBanks < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_resource_banks do |t|
      t.string :hashtag
      t.string :hero_image
      t.string :banner_image
      t.boolean :promoted, default: false
      t.boolean :show_statistics, default: false
      t.integer :decidim_organization_id,
              foreign_key: true,
              index: { name: "index_decidim_resource_banks_on_decidim_organization_id" }

      t.jsonb :title, null: false
      t.jsonb :text, null: false
      t.string :video
      t.string :authorship
      t.string :slug, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :published_at

      t.index [:decidim_organization_id, :slug],
        name: "index_unique_resource_banks_slug_and_organization",
        unique: true
    end
  end
end
