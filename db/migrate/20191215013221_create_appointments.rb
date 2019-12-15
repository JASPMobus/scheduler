class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.string :username
      t.string :provider
      t.datetime :start_time
      t.datetime :end_time
      t.string :notes
    end
  end
end
