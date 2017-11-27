class UreviewsController < ApplicationController
  protect_from_forgery
  before_action :ureview_params, only: [:create]

  def new
    @reviewee = User.find(params[:user_id])
    @request = Request.where(product: @product)
  end

  private

  def ureviews_params
    params.require(:ureview).permit(:content, :overall)
  end
end
