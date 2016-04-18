class CreateStudioIndices < ActiveRecord::Migration
  def change
    create_table :studio_indices do |t|
      t.string :server
      t.string :share
      t.string :path

      t.timestamps null: false
    end
  end
end
