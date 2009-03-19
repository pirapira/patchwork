class PatchesController < ApplicationController
  require_role 'authenticated', :for_all_except => [:show, :index, :feed, :new, :create, :edit, :update]
  
  def new
    @patch = Patch.new
    @prepatch = Patch.find(:first, :readonly, :conditions => ["id = ?", params[:prepatch_id]])
    @postpatch = Patch.find(:first, :readonly, :conditions => ["id = ?", params[:postpatch_id]])
  end

  def create
    @patch = Patch.new(params[:patch])
    @patch.parent_id = nil
    @postpatch = Patch.find(params[:postpatch][:id]) if params[:postpatch]
    @prepatch = Patch.find(params[:prepatch][:id]) if params[:prepatch]

    if (@postpatch && @prepatch) || (@postpatch && @postpatch.id == @patch.id) ||
        (@prepatch && @prepatch.id == @patch.id)
      redirect_to root_path
      return
    end
    
    if !logged_in?
      save_tmp_redirect
      return
    end
    @patch.user = current_user
    @patch.save!

    @patch.postpatches << @postpatch if @postpatch
    @patch.prepatches << @prepatch if @prepatch

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
    @patches = Patch.paginate :page => params[:page], :order => "created_at DESC", :per_page => 5
    @rss = { :controller => :patches, :action => :feed}
  end

  def feed
    @patches = Patch.find(:all, :limit => 20, :order => "created_at DESC")
    render :layout => false
  end

  def update
    @patch = Patch.new(params[:patch])
    if old_version = Patch.find(params[:id])
      @patch.parent_id = old_version.id
    else
      raise "invalid"
    end
    if !logged_in?
      save_tmp_redirect
      return
    end
    @patch.user = current_user
    @patch.save!
    successful_save
  end

  protected

  def successful_save
    redirect_to :action => :show, :id => @patch.id
  end

  def save_tmp_redirect
    session[:writing] = @patch
    session[:prepatch] = @prepatch
    session[:postpatch] = @postpatch
    redirect_to :controller => :sessions, :action => :new
  end
end
