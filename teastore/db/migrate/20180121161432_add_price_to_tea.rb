class AddPriceToTea < ActiveRecord::Migration[5.1]
  def change
    add_column :teas, :price, :decimal
  end
end
