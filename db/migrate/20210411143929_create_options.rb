class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.references :tutor, references: :users, foreign_key: { to_table: :users }, null: true
      t.references :chapter, null: true, foreign_key: true
      t.integer :weight
      t.integer :status

      t.timestamps
    end
  end
end
