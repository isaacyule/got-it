class PagesController < ApplicationController
  protect_from_forgery
  skip_before_action :authenticate_user!, only: [:home]

  def home

  end
end
