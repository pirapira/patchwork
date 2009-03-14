class Patch < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  belongs_to :parent, :class_name => "Patch", :foreign_key => "parent_id"
  has_many :preposts, :foreign_key => 'pre_id'
  has_many :preposts, :foreign_key => 'post_id'
  
  has_many :pre, :through => :preposts
  has_many :post, :through => :preposts

  # Validations
  validates_presence_of :user
end
