class NumberOfSignups < ActiveRecord::Migration
  def change
    change_table :signups do |t|
      t.integer :number_attending
    end
  end
end
