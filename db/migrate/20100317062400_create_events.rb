class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title, :url
      t.datetime :starttime, :endtime
      t.integer :capacity
      t.boolean :all_day, :default => false
      t.references :subdomain
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
