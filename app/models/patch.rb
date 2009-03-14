class Patch < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  belongs_to :parent, :class_name => "Patch", :foreign_key => "parent_id"

  # Validations
  validates_presence_of :user
end
