class AddFaqToSite < ActiveRecord::Migration
  def change
    change_table :subdomains do |t|
      t.text :faq
    end
  end
end
