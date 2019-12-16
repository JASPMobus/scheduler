class ChangePriceToFloatInServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :services, :price
    add_column :services, :price, :float
  end
end
