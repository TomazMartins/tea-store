class AddIsMenuToTea < ActiveRecord::Migration[5.1]
  def change
    add_column :teas, :is_menu, :boolean
  end
end
