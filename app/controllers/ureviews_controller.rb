class UreviewsController < ApplicationController
  protect_from_forgery
  before_action :set_request, only: [:new, :create]

  def new
    @reviewee = @request.user
    @product = @request.product
    @ureview = Ureview.new
    authorize(@ureview)
  end

  def create
    @reviewee = @request.user
    @product = @request.product
    @ureview = Ureview.new(ureviews_params)
    @ureview.request = @request
    @ureview.user = current_user
    @ureview.rating = params[:ureview][:rating]
    @ureview.content = params[:ureview][:content]
    authorize(@ureview)
    if @ureview.save
      redirect_to user_path(@reviewee)
    else
      render :new
    end
  end

  private

  def set_request
    @request = Request.find(params[:request_id])
  end

  def ureviews_params
    params.require(:ureview).permit(:content, :rating, :request_id)
  end
end
