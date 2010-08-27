class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :query_id
      t.string :visible_uri
      t.string :uri
      t.string :name
      t.string :location
      t.string :email
      t.timestamps
    end
  end
  
  def self.down
    drop_table :results
  end
end
