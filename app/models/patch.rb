class Patch < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  belongs_to :parent, :class_name => "Patch", :foreign_key => "parent_id"
  has_many :pre, :through => :prepost
  has_many :post, :through => :prepost

  # Validations
  validates_presence_of :user
end
