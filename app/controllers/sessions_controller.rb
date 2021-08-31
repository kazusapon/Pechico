class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(login_id: session_params[:login_id])
    if @user && @user.authenticate(session_params[:password])
      log_in(@user)
      redirect_to dashboard_index_path and return
    end
    @user ||= User.new
    flash.now[:login_faild] = 'ログインID、もしくはパスワードが違います'
    
    render :new
  end

  def destroy
  end

  private

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
