class RemoveCategoryFromTeas < ActiveRecord::Migration[5.1]
  def change
    remove_column :teas, :category, :string
  end
end
