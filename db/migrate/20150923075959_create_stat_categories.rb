class CreateStatCategories < ActiveRecord::Migration
  def change
    create_table :stat_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
