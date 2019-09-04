class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  skip_before_action :require_login, only: [:index, :new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to @user, notice: 'Пользователь зарегистрирован'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if current_user.update(user_params)
      redirect_to @user, notice: 'Пользователь успешно обновлен.'
    else
      render :edit
    end
  end

  def destroy
    if current_user.destroy
      redirect_to users_url, notice: 'Пользователь удален'
    else
      redirect_to root_path, notice: 'Произошла ошибка'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
