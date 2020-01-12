# frozen_string_literal: true

# require 'socket'

class Users::SessionsController < Devise::SessionsController

  # def create
  #   super
  #   # 既存ユーザーのログイン時のみ対応
  #   current_user.last_login_at = current_user.login_at
  #   current_user.login_at = Time.zone.now
  #   current_user.save!

  #   ip = Socket.ip_address_list.detect(&:ipv4_private?)
  #   ip_address = ip.blank? ? '' : ip.ip_address
  #   UserLoginLog.create(user_id: current_user.id, login_at: current_user.login_at, ip_address: ip_address)
  # end

  # DELETE /resource/sign_out
  def destroy
    p "destroy"
    super
    # UserManagement.update("title=#{params[:chat_preview_list]}","user_id=#{current_user.id}")
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
