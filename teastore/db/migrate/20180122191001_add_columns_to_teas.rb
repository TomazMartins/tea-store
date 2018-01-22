class AddColumnsToTeas < ActiveRecord::Migration[5.1]
  def change
    add_column :teas, :name, :string
    add_column :teas, :made_in, :string
    add_column :teas, :drink_with_milk, :boolean
    add_column :teas, :steeping_time, :integer
    add_column :teas, :stock_quantity, :integer
  end
end
