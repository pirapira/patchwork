class Patch < ActiveRecord::Base
  
  # Relationships
  belongs_to :user

  # Validations
  validates_presence_of :user
end
