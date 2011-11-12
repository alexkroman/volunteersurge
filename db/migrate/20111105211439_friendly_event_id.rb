class FriendlyEventId < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :slug
      t.index :slug, :unique => true
    end
  end
end
