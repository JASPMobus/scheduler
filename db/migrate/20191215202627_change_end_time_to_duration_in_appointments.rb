class ChangeEndTimeToDurationInAppointments < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :end_time
    add_column :appointments, :duration, :integer
  end
end
