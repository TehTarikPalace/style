class CreateRepoStats < ActiveRecord::Migration
  def change
    create_table :repo_stats do |t|
      t.integer :count

      t.timestamps null: false
    end
  end
end
