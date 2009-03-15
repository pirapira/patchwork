class PatchesController < ApplicationController
  require_role 'authenticated', :for_all_except => [:show, :index]
  
  def new
    if logged_in?
      @patch = Patch.new
      @prepatch = Patch.find(:first, :readonly, :conditions => ["id = ?", params[:prepatch_id]])
      @postpatch = Patch.find(:first, :readonly, :conditions => ["id = ?", params[:postpatch_id]])
    else
      flash[:error] = 'Please login first'
      redirect_back_or_default(root_path)
      return
    end
  end

  def create
    @patch = Patch.new(params[:patch])
    @patch.user = current_user
    @patch.parent_id = nil
    @patch.save!

    postpatch = Patch.find(params[:postpatch][:id]) if params[:postpatch]
    prepatch = Patch.find(params[:prepatch][:id]) if params[:prepatch]
    @patch.postpatches << postpatch if postpatch
    @patch.prepatches << prepatch if prepatch

    successful_save
  end
  
  def edit
    @patch = Patch.find(params[:id])
    render :action => "new"
  end

  def show
    @patch = Patch.find(params[:id])
    @prepatches = @patch.before_patches.paginate(:per_page => 5, :page => params[:prepage])
    @postpatches = @patch.after_patches.paginate(:per_page => 5, :page => params[:postpage])
    @forks = @patch.forks.paginate(:per_page => 5, :page => params[:forkpage])
  end

  def index
    @patches = Patch.paginate :page => params[:page], :order => "created_at DESC", :per_page => 10
  end

  def update
    @patch = Patch.new(params[:patch])
    @patch.user = current_user
    if old_version = Patch.find(params[:id])
      @patch.parent_id = old_version.id
    else
      raise "invalid"
    end
    @patch.save!
    successful_save
  end

  protected

  def successful_save
    flash[:notice] = "saved your patch"
    redirect_to :action => :show, :id => @patch.id
  end
end
