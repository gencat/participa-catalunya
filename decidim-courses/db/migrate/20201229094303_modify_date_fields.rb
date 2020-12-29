class ModifyDateFields < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_courses do |t|
      t.remove :course_date
      t.column :start_date, :datetime
      t.column :end_date, :datetime
      t.change :duration, :text
      t.column :schedule, :text
    end
  end
end
