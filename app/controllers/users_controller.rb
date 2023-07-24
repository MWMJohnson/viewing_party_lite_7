class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    # require 'pry'; binding.pry
    if user.save
      # require 'pry'; binding.pry
      redirect_to "/users/#{user.id}"
    else
      flash[:error] = "Error: #{user.errors.full_messages.to_sentence}"
      redirect_to register_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
