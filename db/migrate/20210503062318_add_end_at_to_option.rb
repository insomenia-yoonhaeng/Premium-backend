class AddEndAtToOption < ActiveRecord::Migration[6.0]
  def change
    add_column :options, :end_at, :datetime
  end
end
