class RandomController < ApplicationController

  def index
    @seq = Patch.random_seq
    if @seq.empty?
      redirect_to :controller => "patches", :action => "new"
    end
  end

  def show
    @seq = Patch.find(params[:id]).rseq
    render :action => :index
  end
end
