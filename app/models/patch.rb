class Patch < ActiveRecord::Base
  acts_as_textiled :content, :description
  acts_as_viewed

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
    r = inner.uniq
    return r
  end
  def after_patches
    inner = possible_inner [], :postpatches
    r = inner.uniq
    return r
  end
  def forks
    Patch.find(:all, :conditions => ["parent_id = ?", id],
               :order => "created_at desc")
  end
  def summary(size=26)
    ucontent = content(:plain).scan(/./u)
    if ucontent.size < size then
      ucontent
    else 
      ucontent.first(size - 3) + "...".scan(/./u)
    end
  end
  def Patch.random_seq
    r = Patch.find(:all).rand
    return [] unless r
    return r.rseq
  end
  def rseq
    random_above([]) + [self] + random_below([])
  end
  def added_below
    prepatches.detect { |p| p.created_at < created_at }
  end
  def added_above
    postpatches.detect { |p| p.created_at < created_at }
  end
  def for_whom
    return User.find(:first, :conditions => ["id = ?", for_cache]) if for_cached

    self.for_cache =
      if parent then parent.user.id
      elsif added_below then added_below.user.id
      elsif added_above then added_above.user.id
      else nil
      end
    self.for_cached = true
    self.save!
    return for_whom
  end
  protected

  def possible_inner searched, met
    if searched.include? self
      return []
    end
    searched = searched + [self]

    r = self.send met
    r = r.sort { |a,b| b.created_at <=> a.created_at }
    self.forks.each { |p| r += p.possible_inner searched, met }
    r += self.parent.possible_inner searched, met if self.parent

    return r
  end

  def random_above cont
    if before_patches.empty? then
      cont
    else
      p = before_patches.rand
      p.random_above([p] + cont)
    end
  end

  def random_below cont
    if after_patches.empty? then
      cont
    else
      p = after_patches.rand
      p.random_below(cont + [p])
    end
  end

end
