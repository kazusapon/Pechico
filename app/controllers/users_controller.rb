class UsersController < ApplicationController
  PER = 10

  def index
    @users = User.page(params[:page]).per(PER)
  end

  def new
    @title = 'ユーザ登録'
    @user = User.new

    render 'save_modal'
  end

  def create
    @user = User.new(user_params)
    @user.save!
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{users_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'users/error.js.erb' }
    end
  end

  def edit
    @title = 'ユーザ更新'
    @user = User.with_deleted.find(params[:id])
    
    render 'save_modal'
  end

  def update
    @user = User.find(params[:id])
    @user.update!(user_params)
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{users_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'users/error.js.erb' }
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    user.logical_delete if user

    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :login_id, :password, :password_confirmation)
  end
end
