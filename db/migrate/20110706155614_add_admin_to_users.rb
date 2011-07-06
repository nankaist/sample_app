class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean # the default value of :admin attr is nil aka false
  end

  def self.down
    remove_column :users, :admin
  end
end
