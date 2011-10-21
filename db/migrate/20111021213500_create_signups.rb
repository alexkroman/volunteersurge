class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.references :user
      t.references :event
      t.timestamps
    end
  end
end
