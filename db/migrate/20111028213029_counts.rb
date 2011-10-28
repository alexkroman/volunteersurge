class Counts < ActiveRecord::Migration
  def up
    add_column :events, :signups_count, :integer, :default => 0
  end

  def down
    drop_column :events, :signups_count
  end
end
