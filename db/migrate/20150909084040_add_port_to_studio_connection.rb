class AddPortToStudioConnection < ActiveRecord::Migration
  def change
    add_column :studio_connections, :port, :integer
  end
end
