class AddRoleAuthenticated < ActiveRecord::Migration
  def self.up
    Role.create(:name => 'authenticated')
  end

  def self.down
    Role.find(:first, :conditions => ["name = ?", 'authenticated']).delete!
  end
end
