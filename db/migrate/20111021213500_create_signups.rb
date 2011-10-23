class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.references :user
      t.references :event
      t.references :event_series
      t.references :subdomain
      t.timestamps
    end
  end
end
