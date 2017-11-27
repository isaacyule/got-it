class UreviewsController < ApplicationController
  protect_from_forgery
  before_action :ureview_params, only: [:create]

  def new
    @request = Request.find(params[:request_id])
    @reviewee = @request.user
    @product = @request.product
    @ureview = Ureview.new
    authorize(@ureview)
  end

  private

  def ureviews_params
    params.require(:ureview).permit(:product_id, :request_id)
  end
end
