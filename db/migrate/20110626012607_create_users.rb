class CreateUsers < ActiveRecord::Migration
  def self.up #function for command: rake db:migrate to create the users database
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down # function for command: rake db:rollback to drop users database
    drop_table :users
  end
end
