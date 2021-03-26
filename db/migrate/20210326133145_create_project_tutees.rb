class CreateProjectTutees < ActiveRecord::Migration[6.0]
  def change
    create_table :project_tutees do |t|
      t.references :project
      t.references :tutee, references: :users, foreign_key: { to_table: :users }
      t.timestamps
    end
    remove_reference :users, :project
  end
end
