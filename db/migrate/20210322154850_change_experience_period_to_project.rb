class ChangeExperiencePeriodToProject < ActiveRecord::Migration[6.0]
  def change
		add_column :projects, :experience_period, :integer
  end
end
