class Patch < ActiveRecord::Base
  
  # Relationships
  belongs_to :user
  belongs_to :parent, :class_name => "Patch", :foreign_key => "parent_id"
  has_many :ahead_preposts, :class_name => "Prepost", :foreign_key => 'prepatch_id'
  has_many :behind_preposts, :class_name => "Prepost", :foreign_key => 'postpatch_id'
  
  has_many :prepatches, :class_name => "Patch", :through => :behind_preposts, :foreign_key => 'prepatch_id'
  has_many :postpatches, :class_name => "Patch", :through => :ahead_preposts, :foreign_key => 'postpatch_id'

  # Validations
  validates_presence_of :user

  def before_patches
    prepatches
  end

  def after_patches
    postpatches
  end

  def summery
    content
  end
end
