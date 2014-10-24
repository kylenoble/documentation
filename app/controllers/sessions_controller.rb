class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to @current_user
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      redirect_to '/login'
    end
  end

  def destroy
  	session.delete(:user_id)
    @current_user = nil
    redirect_to root_url
  end
end
