class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User created successfully!"
      redirect_to "/login"
    else
      render 'new'
    end
  end

  private

	def user_params
	  params.require(:user).permit(:name, :email, :password,
	                               :password_confirmation, :admin_key)
	end
end
