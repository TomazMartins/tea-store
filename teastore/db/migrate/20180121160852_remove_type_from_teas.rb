class RemoveTypeFromTeas < ActiveRecord::Migration[5.1]
  def change
    remove_column :teas, :type, :string
  end
end
