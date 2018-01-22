class AddQuantityToTea < ActiveRecord::Migration[5.1]
  def change
    add_column :teas, :quantity, :integer
  end
end
