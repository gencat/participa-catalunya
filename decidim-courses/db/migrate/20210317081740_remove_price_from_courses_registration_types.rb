# frozen_string_literal: true

class RemovePriceFromCoursesRegistrationTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_courses_registration_types, :price
  end
end
