class Patch < ActiveRecord::Base
  
  # Relationships
  belong_to :user

  # Validations
  validates_presence_of :user
end
