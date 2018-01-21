class RenameNameToCategory < ActiveRecord::Migration[5.1]
  def change
    rename_column :teas, :name, :category
  end
end
