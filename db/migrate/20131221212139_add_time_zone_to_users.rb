class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string # It's a string like 'Bangkok', etc; not a timestamp number.
  end
end
