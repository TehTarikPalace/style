class AddCaptionToStudioIndex < ActiveRecord::Migration
  def change
    add_column :studio_indices, :caption, :string
  end
end
