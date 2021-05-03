class AddBookIdToProject < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :book, null: true, foreign_key: true
  end
end
