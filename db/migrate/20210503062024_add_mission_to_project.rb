class AddMissionToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :mission, :string
  end
end
