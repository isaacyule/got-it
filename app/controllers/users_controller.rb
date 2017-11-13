class UsersController < ApplicationController
  protect_from_forgery
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:new, :create, :show]


end
