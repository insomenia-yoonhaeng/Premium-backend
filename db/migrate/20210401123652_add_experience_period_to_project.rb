class AddExperiencePeriodToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :experience_period, :integer, default: 0
  end
end
