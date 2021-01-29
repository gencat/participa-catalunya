# frozen_string_literal: true

class CreateResourceBankUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_resource_bank_user_roles do |t|
      t.integer :decidim_user_id
      t.integer :decidim_resource_bank_id
      t.string :role
      t.timestamps
    end

    add_index :decidim_resource_bank_user_roles,
              [:decidim_resource_bank_id, :decidim_user_id, :role],
              unique: true,
              name: "index_unique_user_and_resource_bank_role"

    add_index :decidim_resource_bank_user_roles, :decidim_user_id
  end
end
