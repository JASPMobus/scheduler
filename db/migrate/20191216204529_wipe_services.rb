class WipeServices < ActiveRecord::Migration[5.2]
  def change
    drop_table :services

    create_table "services" do |t|
      t.string "name"
      t.string "description"
      t.float "price"
      t.integer "appointment_id"
    end
  end
end
