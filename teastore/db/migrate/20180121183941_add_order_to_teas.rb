class AddOrderToTeas < ActiveRecord::Migration[5.1]
  def change
    add_reference :teas, :order, foreign_key: true
  end
end
