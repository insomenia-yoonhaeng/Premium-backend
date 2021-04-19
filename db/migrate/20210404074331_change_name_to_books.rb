class ChangeNameToBooks < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :thumbnail, :image
  end
end
