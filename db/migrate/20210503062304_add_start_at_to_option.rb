class AddStartAtToOption < ActiveRecord::Migration[6.0]
  def change
    add_column :options, :start_at, :datetime
  end
end
