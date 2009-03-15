class Patch < ActiveRecord::Base

  # Relationships
  belongs_to :user
  belongs_to :parent, :class_name => "Patch", :foreign_key => "parent_id"
  has_many :ahead_preposts, :class_name => "Prepost",
           :foreign_key => 'prepatch_id'
  has_many :behind_preposts, :class_name => "Prepost",
           :foreign_key => 'postpatch_id'

  has_many :prepatches, :class_name => "Patch", :through => :behind_preposts,
           :foreign_key => 'prepatch_id'
  has_many :postpatches, :class_name => "Patch", :through => :ahead_preposts,
           :foreign_key => 'postpatch_id'

  # Validations
  validates_presence_of :user

  def before_patches
    inner = possible_inner [], :prepatches
    return inner.uniq
  end

  def after_patches
    inner = possible_inner [], :postpatches
    return inner.uniq
  end

  def forks
    Patch.find(:all, :conditions => ["parent_id = ?", id])
  end

  def summary
    ucontent = content.scan(/./u)
    size = 18
    ucontent =
      if ucontent.size < size / 2
      then ucontent
      else ucontent.first(size / 2) + "...".scan(/./u) + ucontent.last(size / 2)
      end
    return ucontent
  end

  protected

  def possible_inner searched, met
    if parent_id.nil? || (searched.include? parent) then
      return (self.send met)
    else
      p = parent.send met
      new_searched = searched + [parent]
      q = parent.possible_inner new_searched, met
      return p + q
    end
  end

end
