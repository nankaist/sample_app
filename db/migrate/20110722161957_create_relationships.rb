class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # add index on each column for looking-up efficiency
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], :unique => true # enforce uniqueness of pairs, so a user can't follow another user more than once
  end

  def self.down
    drop_table :relationships
  end
end
