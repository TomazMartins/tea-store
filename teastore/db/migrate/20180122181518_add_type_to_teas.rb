class AddTypeToTeas < ActiveRecord::Migration[5.1]
  def change
    add_column :teas, :type, :string
  end
end
