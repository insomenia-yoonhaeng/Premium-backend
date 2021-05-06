class AddDurationToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :duration, :integer, default: 0
  end
end
