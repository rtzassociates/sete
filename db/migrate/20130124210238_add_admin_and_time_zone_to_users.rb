class AddAdminAndTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    add_column :users, :time_zone, :string
  end
end
