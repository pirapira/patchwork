class AddViewingTable < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.create_viewings_table
    Patch.add_viewings_columns
  end

  def self.down
    Patch.remove_viewings_columns
    ActiveRecord::Base.drop_viewings_table
  end
end
