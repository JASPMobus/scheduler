class AddAppointmentIdToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :appointment_id, :integer
  end
end
