class AddUsernameToStudioIndices < ActiveRecord::Migration
  def change
    add_column :studio_indices, :username, :string
    add_column :studio_indices, :password, :string
    add_column :studio_indices, :workgroup, :string
  end
end
