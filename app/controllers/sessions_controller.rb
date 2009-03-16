class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
  end

  def create
    logout_keeping_session!
    if using_open_id?
      open_id_authentication
    else
      note_failed_login
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(root_path)
  end

  def open_id_authentication
    authenticate_with_open_id(params[:openid_url],
                                :required => [:nickname, :email]) do
        |result, identity_url, registration|
      if result.successful? then
        if self.current_user = User.find_by_identity_url(identity_url) then
          successful_login
        else
          create_new_user(:identity_url => identity_url,
                               :login => registration['nickname'],
                          :email => registration['email'])
          self.current_user = User.find_by_identity_url(identity_url)
          successful_login
        end
      else
        flash[:error] = result.message || "Sorry no user with that identity URL exists"
        @remember_me = params[:remember_me]
        render :action => :new
      end
    end
  end

  protected

  def successful_login
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    if session[:writing]
      @patch = session[:writing]
      session[:writing] = nil
      @patch.user = current_user
      @patch.save!

      postpatch = session[:postpatch]
      prepatch = session[:prepatch]
      session[:postpatch] = nil
      session[:prepatch] = nil
      
      @patch.postpatches << postpatch if postpatch
      @patch.prepatches << prepatch if prepatch
      
      redirect_to :controller => :patches,
        :action => :show, :id => @patch.id
      return
    end
    redirect_back_or_default(root_path)
    flash[:notice] = "Logged in successfully"
  end

  def note_failed_login
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      @user.register_openid!
    end

    if @user.errors.empty?
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      @user.roles << Role.find(:first,
                               :conditions => [ "name = ?",  'authenticated'])
    else
      failed_creation
    end
  end

  def failed_creation(message = 'Sorry, there was an error creating your account')
    flash[:error] = message
    render :action => :new
  end

end
