class Prepost < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :prepatch, :class_name => "patch", :dependent => :destroy
  belongs_to :postpatch, :class_name => "patch", :dependent => :destroy
end
