class RemoveUserIdFromBoards < ActiveRecord::Migration
  def self.up
    # this is no longer needed since we have creator_id and updater_id
    remove_column :boards, :user_id
  end

  def self.down
    add_column :boards, :user_id, :integer
  end
end
