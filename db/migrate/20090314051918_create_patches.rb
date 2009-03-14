class CreatePatches < ActiveRecord::Migration
  def self.up
    create_table :patches do |t|
      t.integer	"user_id"
      t.text	"content"
      t.timestamps
    end
  end

  def self.down
    drop_table :patches
  end
end
