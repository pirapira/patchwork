class AddParentPatch < ActiveRecord::Migration
  def self.up
    add_column "patches", "parent_id", :integer
  end

  def self.down
  end
end
