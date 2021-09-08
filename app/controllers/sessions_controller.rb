class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.without_deleted.find_by(login_id: session_params[:login_id])
    if @user && @user.authenticate(session_params[:password])
      log_in(@user)
      redirect_to dashboard_index_path and return
    end
    @user ||= User.new
    flash.now[:login_faild] = 'ログインID、もしくはパスワードが違います'
    
    render :new
  end

  def destroy
    log_out if log_in?
    redirect_to root_path
  end

  private

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
