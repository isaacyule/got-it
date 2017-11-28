class UsersController < ApplicationController
  protect_from_forgery
  before_action :authenticate_user!
  before_action :set_user, only: [:show]
  before_action :set_requests, only: [:show, :pending, :declined, :accepted]


  def show
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

  def accepted
  end

  def declined
  end

  def pending
  end

  private

  def set_requests
    @user = current_user
    authorize(@user)

    @pending_requests = []
    @accepted_requests = []
    @declined_requests = []

    @user.products.each do |product|
      product.requests.each do |request|
        if request.status == "Pending"
          @pending_requests << request
        elsif request.status == "Accepted"
          @accepted_requests << request
        elsif request.status == "Declined"
          @declined_requests << request
        else
        end
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :profile_text, :profile_photo, :address, :phone, :latitude, :longitude)
  end

  def set_user_rating

  end

end
