class AddRestToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :rest, :integer, default: 0
  end
end
