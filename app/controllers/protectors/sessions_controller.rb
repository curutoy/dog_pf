# frozen_string_literal: true

class Protectors::SessionsController < Devise::SessionsController
  before_action :authenticate_user!, expect: [:new, :create]
  before_action :authenticate_protector!, expect: [:new, :create]

  def new_guest
    protector = Protector.guest
    sign_in protector
    redirect_to root_path, notice: "テストユーザーとしてログインしました。"
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :password_confirmation])
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    new_protector_session_path
  end
end
