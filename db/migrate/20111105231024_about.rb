class About < ActiveRecord::Migration
  def change
    change_table :subdomains do |t|
      t.text :about
    end
  end
end
