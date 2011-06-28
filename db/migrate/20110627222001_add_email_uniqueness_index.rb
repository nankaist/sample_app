class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    #add :email column as index of table :users, & the unique option enforces uniqueness
    add_index(:users, :email, {:unique=>true})
  end

  def self.down
    remove_index :users, :email
  end
end
