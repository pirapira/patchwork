class CreatePreposts < ActiveRecord::Migration
  def self.up
    create_table :preposts do |t|
      t.integer "user_id"
      t.integer "prepatch_id"
      t.integer "postpatch_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :preposts
  end
end
