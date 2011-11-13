class GroupDescription < ActiveRecord::Migration
  def change
    change_table :signups do |t|
      t.text :description
    end
  end
end
