class RemoveStandardFromServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :services, :standard
  end
end
