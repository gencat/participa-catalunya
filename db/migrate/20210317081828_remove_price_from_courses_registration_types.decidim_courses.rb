# frozen_string_literal: true
# This migration comes from decidim_courses (originally 20210317081740)

class RemovePriceFromCoursesRegistrationTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_courses_registration_types, :price
  end
end
