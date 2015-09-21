class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.references :studio_connection_id, index: true

      t.timestamps null: false
    end
    add_foreign_key :repositories, :studio_connection_ids
  end
end
