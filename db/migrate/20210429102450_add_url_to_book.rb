class AddUrlToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :url, :string
  end
end
