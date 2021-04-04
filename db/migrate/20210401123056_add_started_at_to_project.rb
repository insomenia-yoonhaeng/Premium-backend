class AddStartedAtToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :started_at, :datetime
  end
end
