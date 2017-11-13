class UsersController < ApplicationController
  protect_from_forgery
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:new, :create, :show]

  def show
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :profile_text, :profile_photo, :street, :town, :country, :phone)
  end
end
