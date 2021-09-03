class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @title = 'ユーザ登録'
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path }
        format.js { render js: "window.location = '#{users_path}'" }
        return
      end

      format.html { render partial: 'users/errorjs.erb' }
      format.js { render partial: 'users/error.js.erb' }
    end
  end

  def edit
    @title = 'ユーザ更新'
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :login_id, :password, :password_confirmation)
  end
end
