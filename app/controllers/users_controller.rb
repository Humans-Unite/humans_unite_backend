# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user! 

  def index
    @users = User.all
    render json: @users 
  end

end
