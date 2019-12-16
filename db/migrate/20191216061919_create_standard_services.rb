class CreateStandardServices < ActiveRecord::Migration[5.2]
  def change
    create_table :standard_services do |t|
      t.string :name
      t.string :description
      t.float :price
    end
  end
end
