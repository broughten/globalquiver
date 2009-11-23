class PickupTimesUsersJoin < ActiveRecord::Migration
  def self.up
    create_table 'pickup_times_users', :id => false do |t|
      t.column 'pickup_time_id', :integer
      t.column 'user_id', :integer
    end
  end

  def self.down
    drop_table 'pickup_times_users'
  end
end
