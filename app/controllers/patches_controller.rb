class PatchesController < ApplicationController
#  require_role "subscriber", :for => :new
  
  def new
    @patch = Patch.new
  end

  def create
    @patch = Patch.new(params[:patch])
    @patch.user = current_user
    @patch.save!
    flash[:notice] = "saved your patch"
    redirect_back_or_default(root_path)
  end

  def show
    @patch = Patch.find(params[:id])
  end
  
  def index
    @patches = Patch.find(:all)
  end
end
