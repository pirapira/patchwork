class PatchesController < ApplicationController
#  require_role "subscriber", :for => :new
  
  def new
    if logged_in?
      @patch = Patch.new
    else
      flash[:error] = 'Please login first'
      redirect_back_or_default(root_path)
      return
    end
  end

  def create
    @patch = Patch.new(params[:patch])
    if current_user.nil?
      flash[:error] = 'Please login first'
      redirect_back_or_default(root_path)
      return
    end
    @patch.user = current_user
    @patch.parent_id = nil
    @patch.save!
    flash[:notice] = "saved your patch"
    redirect_back_or_default(root_path)
  end
  
  def edit
    if current_user.nil?
      flash[:error] = 'Please login first'
      redirect_back_or_default(root_path)
      return
    end
    @patch = Patch.find(params[:id])
    render :action => "new"
  end

  def show
    @patch = Patch.find(params[:id])
  end

  def index
    @patches = Patch.find(:all)
  end

  def update
    if current_user.nil?
      flash[:error] = 'Please login first'
      redirect_back_or_default(root_path)
      return
    end
    @patch = Patch.new(params[:patch])
    @patch.user = current_user
    if old_version = Patch.find(params[:id])
      @patch.parent_id = old_version.id
    else
      raise "invalid"
    end
    @patch.save!
    flash[:notice] = "saved your patch"
    redirect_back_or_default(root_path)
  end
end
