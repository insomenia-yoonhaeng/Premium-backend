class AddExperiencePeriodToProject < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :experience_period
    add_column :projects, :experience_period, :integer, default: 0
  end
end
