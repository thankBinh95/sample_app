class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash_info"
      redirect_to root_url
    else
      flash.now[:danger] = t ".flash_danger"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".vali_pass")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t ".flash_sucess"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email] if @user.nil?
    flash[:danger] = t ".flash_nil_user"
    redirect_to root_url
  end

  def valid_user
    return unless @user &.activated? &.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return if @user.password_reset_expired?
    flash[:danger] = t ".flash_error"
    redirect_to new_password_reset_url
  end
end
