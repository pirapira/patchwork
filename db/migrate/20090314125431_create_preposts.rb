class CreatePreposts < ActiveRecord::Migration
  def self.up
    create_table :preposts do |t|
      t.integer "user_id"
      t.integer "pre_id"
      t.integer "post_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :preposts
  end
end
