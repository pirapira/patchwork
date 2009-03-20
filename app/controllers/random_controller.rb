class RandomController < ApplicationController

  def index
    @seq = Patch.random_seq
    @seq.each { |p| add_view p }
    if @seq.empty?
      redirect_to :controller => "patches", :action => "new"
    end
  end

  def show
    @seq = Patch.find(params[:id]).rseq
    @seq.each { |p| add_view p }
    render :action => :index
  end

  protected

  def add_view(p = @patch)
    if current_user.nil? then
      p.view request.remote_ip, current_user
    else
      p.view request.remote_ip
    end
  end

end
