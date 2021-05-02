class ChangeNameToProjectTutee < ActiveRecord::Migration[6.0]
  def change
    rename_table :project_tutees, :attendances
  end
end
