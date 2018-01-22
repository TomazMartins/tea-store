class RenameColumnFromTeas < ActiveRecord::Migration[5.1]
  def change
    rename_column :teas, :quantity, :ordered_quantity
  end
end
