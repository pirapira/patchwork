class Patch < ActiveRecord::Base
  acts_as_textiled :content, :description

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
    Patch.find(:all, :conditions => ["parent_id = ?", id])
  end

  def summary
    ucontent = content(:plain).scan(/./u)
    size = 26
    ucontent =
      if ucontent.size < size
      then ucontent
      else ucontent.first(size - 3) + "...".scan(/./u)
      end
    return ucontent
  end

  def Patch.random_seq
    all = Patch.find(:all)
    if all.empty?
      return []
    end
    return all.rand.rseq
  end

  def rseq
    random_above([]) + [self] + random_below([])
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
    if prepatches.empty? then
      cont
    else
      p = prepatches.rand
      p.random_above([p] + cont)
    end
  end

  def random_below cont
    if postpatches.empty? then
      cont
    else
      p = postpatches.rand
      p.random_below(cont + [p])
    end
  end

end
