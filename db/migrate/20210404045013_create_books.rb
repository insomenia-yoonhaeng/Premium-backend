class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :author
      t.text :content
      t.string :isbn
      t.string :publisher
      t.string :title
      t.string :thumbnail
      t.timestamps
    end
  end
end
