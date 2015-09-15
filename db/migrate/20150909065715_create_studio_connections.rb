class CreateStudioConnections < ActiveRecord::Migration
  def change
    create_table :studio_connections do |t|
      t.string :username
      t.string :password
      t.string :oracle_host
      t.string :oracle_instance

      t.timestamps null: false
    end
  end
end
