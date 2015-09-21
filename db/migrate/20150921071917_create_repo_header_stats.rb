class CreateRepoHeaderStats < ActiveRecord::Migration
  def change
    create_table :repo_header_stats do |t|
      t.references :repository, index: true
      t.references :repo_stat, index: true
      t.references :stat_header, index: true

      t.timestamps null: false
    end
    add_foreign_key :repo_header_stats, :repositories
    add_foreign_key :repo_header_stats, :repo_stats
    add_foreign_key :repo_header_stats, :stat_headers
  end
end
