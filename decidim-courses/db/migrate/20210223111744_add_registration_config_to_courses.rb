class AddRegistrationConfigToCourses < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_courses, bulk: true do |t|
      t.boolean "registrations_enabled", default: false, null: false
      t.integer "available_slots", default: 0, null: false
      t.jsonb "registration_terms"
    end
  end
end
