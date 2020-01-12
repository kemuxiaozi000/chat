# frozen_string_literal: true
class ApplicationController < ActionController::Base
  # before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :session_save
  require 'net/http'
  require 'net/https'
  require "open-uri"
  require 'uri'
  require 'json'
  private
  RAILS_ROOT = ENV['RAILS_ROOT']
  # I18n.locale をセットする
  def set_locale
    I18n.locale = locale_in_params || locale_return_language || I18n.default_locale
  end

  def uploadFile(file)
    if !file.original_filename.empty?
      @filename=getFileName(file.original_filename) +":::fileuid:" +SecureRandom.hex(6)
      path = File.join Rails.root, 'public', 'tmpfile'
      FileUtils.mkdir_p(path) unless File.exist?(path)
      File.open(File.join(path, "#{@filename}"), "wb") do |f|
      # File.open("#{RAILS_ROOT}/public/images/#{@filename}", "wb") do |f|
        f.write(file.read)
      end
      return @filename
    end
  end

  def downloadFile(filename)
    path = File.join Rails.root, 'public', 'tmpfile'
    send_file(File.join(path, filename))
  end

  def getFileName(filename)
    if !filename.nil?
      return filename
    end
  end

  # params の locale の値（優先すべき）
  # @return [Symbol]
  #   params から取った locale
  #   有効な値でなければ :en
  #   取得できなかった場合 nil
  def locale_in_params
    params[:locale].to_sym.presence_in(I18n.available_locales) || I18n.default_locale if params[:locale].present?
  end

  # 環境変数 HTTP_ACCEPT_LANGUAGE を順に検証し、最初に一致した有効な locale を返す
  # @return [Symbol]  環境変数 HTTP_ACCEPT_LANGUAGE から取った locale 。取得できなかった場合 nil
  def locale_in_accept_language
    request.env['HTTP_ACCEPT_LANGUAGE']
           .to_s # nil 対策
           .split(',')
           .map { |loc| loc.scan(/([a-z]{2}(?:-[a-z]{2})?).*/).last.first.to_sym.downcase }
           .select { |loc| %i[zh zh-cn zh-hant-cn ja ja-jp en].include?(loc.downcase) }
           .first
  end

  def locale_return_language
    locale = locale_in_accept_language.to_s.downcase
    case locale.slice(0, 2)
    when 'en'
      return :en
    when 'ja'
      return :ja
    when 'zh'
      return :'zh-CN'
    else
      return nil
    end
  end

  # 全リンクに locale 情報をセットする
  # @return [Hash] locale をキーとするハッシュ
  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  protected

  def configure_permitted_parameters
    # strong parametersを設定し、phone_numberを許可
    added_attrs = [ :nickname, :email, :password, :password_confirmation　]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    # devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:phone_number, :password, :password_confirmation) }
    # devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:phone_number, :password, :password_confirmation) }
    # devise_parameter_sanitizer.permit(
    #   :sign_up, keys: [:full_name, :nickname, :sex, :birthday, :address, :garage, :year_of_experience, :qualification, :specialty, public_status: []]
    # )
    # devise_parameter_sanitizer.permit(
    #   :account_update, keys: [:full_name, :nickname, :sex, :birthday, :address, :garage, :year_of_experience,
    #                           :qualification, :specialty, :user_status, public_status: []]
    # )
  end
end