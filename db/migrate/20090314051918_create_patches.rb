class CreatePatches < ActiveRecord::Migration
  def self.up
    create_table :patches do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :patches
  end
end
