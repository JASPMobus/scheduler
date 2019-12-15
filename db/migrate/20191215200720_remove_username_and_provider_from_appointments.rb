class RemoveUsernameAndProviderFromAppointments < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :username
    remove_column :appointments, :provider
  end
end
