class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.integer :result_id
      t.string :address
      t.timestamps
    end
  end
  
  def self.down
    drop_table :emails
  end
end
