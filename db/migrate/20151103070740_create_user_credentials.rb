class CreateUserCredentials < ActiveRecord::Migration
  def change
    create_table :user_credentials do |t|
      t.references :user, index: true
      t.references :studio_connection, index: true
      t.string :username
      t.string :password

      t.timestamps null: false
    end
    add_foreign_key :user_credentials, :users
    add_foreign_key :user_credentials, :studio_connections
  end
end
