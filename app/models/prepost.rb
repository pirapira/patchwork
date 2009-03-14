class Prepost < ActiveRecord::Base

  # Relationships
  belongs_to :user, :dependent => :destroy
  belongs_to :prepatch, :class_name => "patch", :dependent => :destroy
  belongs_to :postpatch, :class_name => "patch", :dependent => :destroy

  # Validations
  validates_presence_of :prepatch
  validates_presence_of :postpatch
end
