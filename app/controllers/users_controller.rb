class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  require_role 'authenticated', :for_all_except => [:show, :feed]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @patches = Patch.paginate :page => params[:page],
    :order => "created_at DESC", :per_page => 5,
    :conditions => ["user_id = ?", params[:id]]
    @for_patches = @user.for_patches.paginate :page => params[:for_page], :per_page => 5
    @rss = { :controller => :users, :action => :feed, :id => params[:id] }
  end

  def feed
    @user = User.find(params[:id])
    @patches = Patch.find(:all, :limit => 20, :order => "created_at DESC",
                          :conditions => ["user_id = ?", params[:id]])
    render :layout => false
  end

  def update
    @user = current_user
    if new_name = params[:user][:name]
      @user.name = new_name
      @user.save!
      flash[:notice] = 'your name saved'
      redirect_to :action => :show
    else
      flash[:error] = 'something wrong'
      redirect_to :action => :show
    end
  end

  def create
    logout_keeping_session!
    if using_open_id?
      authenticate_with_open_id(params[:openid_url],
                                :return_to => open_id_create_url,
                                :required => [:nickname, :email]) do
        |result, identity_url, registration|
        if result.successful?
          create_new_user(:identity_url => identity_url,
                          :login => registration['nickname'],
                          :email => registration['email'])
        else
          failed_creation(result.message || "Sorry, something went wrong")
        end
      end
    else
      create_new_user(params[:user])
    end
  end

end
