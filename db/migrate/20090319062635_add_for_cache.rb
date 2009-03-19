class AddForCache < ActiveRecord::Migration
  def self.up
    add_column "patches", "for_cache", :integer
    add_column "patches", "for_cached", :boolean, :default => false
  end

  def self.down
    remove_column "patches", "for_cache"
    remove_column "patches", "for_cached"
  end
end
