class Prepost < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :pre, :class_name => "patch", :dependent => :destroy
  belongs_to :post, :class_name => "patch", :dependent => :destroy
end
