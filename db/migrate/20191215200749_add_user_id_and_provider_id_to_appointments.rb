class AddUserIdAndProviderIdToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :user_id, :integer
    add_column :appointments, :provider_id, :integer
  end
end
