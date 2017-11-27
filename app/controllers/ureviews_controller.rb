class UreviewController < ApplicationController
  protect_from_forgery
  before_action :user_review_params, only: [:create]

  def new
  end

  def private
    params.require(:user_review).permit(:content, :overall)
  end
end
