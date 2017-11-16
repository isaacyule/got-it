class UsersController < ApplicationController
  protect_from_forgery
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :requests]
  before_action :set_requests, only: [:show, :requests]

  def show
    authorize(@user)
  end

  def edit
    @user = current_user
    authorize(@user)
  end

  def update
    @user = current_user
    @user.update(user_params)
    authorize(@user)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def requests
    authorize(@user)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def set_requests
     requests = []
    @user.products.each do |product|
      product.requests.each { |request| requests << request }
    end

    @requests = requests
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :profile_text, :profile_photo, :address, :phone, :latitude, :longitude)
  end
end
