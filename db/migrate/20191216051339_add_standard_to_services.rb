class AddStandardToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :standard, :boolean
  end
end
