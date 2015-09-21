class CreateStatHeaders < ActiveRecord::Migration
  def change
    create_table :stat_headers do |t|
      t.string :name
      t.string :display_name
      t.references :repo_stat_id, index: true

      t.timestamps null: false
    end
    add_foreign_key :stat_headers, :repo_stat_ids
  end
end
