class AddTrackbackUrl < ActiveRecord::Migration
  def self.up
    add_column 'patches', 'trackback_url', :string
  end

  def self.down
    remove_column 'patches', 'trackback_url'
  end
end
