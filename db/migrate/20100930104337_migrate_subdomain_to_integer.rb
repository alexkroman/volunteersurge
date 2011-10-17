class MigrateSubdomainToInteger < ActiveRecord::Migration
  def self.up
    remove_column :users, :subdomain_name
    add_column :users, :subdomain_id, :integer
    add_index :users, :subdomain_id
    add_index :subdomains, :name
  end

  def self.down
    add_column :users, :subdomain_name, :limit => 40
    remove_column :users, :subdomain_id
    remove_index :users, :subdomain_id
    remove_index :subdomains, :name
  end
end
