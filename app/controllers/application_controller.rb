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
      @filename=getFileName(file.original_filename) +"&fileuid=" +SecureRandom.hex(6)
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

  def user_permit_check
    if session[:logmsg].nil?
      session[:logmsg] = LogMsg.instance
    end
    if session[:current_user_id].nil? || session[:token].nil? || session[:role].nil?
      if session[:current_user_id].nil?
        # $logdata.warn(session[:logmsg].msg_get('W_MSG0001', 'tourist'))
      else
        # $logdata.warn(session[:logmsg].msg_get('W_MSG0001', session[:current_user_id]))
      end
      session_clear
      redirect_to("//#{ENV['REPAIRCASE_FQDN']}#{ENV['REPAIRCASE_FQDN_PORT']}/sign_in.html")
      return false
    end

    begin
      flag = false
      if ENV['REDIS_HOST'] == ""
        flag = isTokenValueExist?(session[:token])
      else
        flag = true if $redis.get(session[:token]).present?
      end
      if !flag
      #if isTokenValueExist?(session[:token]) == false
        # $logdata.warn(session[:logmsg].msg_get('W_MSG0001', session[:current_user_id]))
        session_clear
        redirect_to("//#{ENV['REPAIRCASE_FQDN']}#{ENV['REPAIRCASE_FQDN_PORT']}/sign_in.html")
        return false
      end
    rescue => e
      redirect_to("//#{ENV['REPAIRCASE_FQDN']}#{ENV['REPAIRCASE_FQDN_PORT']}/sign_in.html")
        return false
    end

    #session[:last_time] = "2019-06-05 10:18:26 +0800"
    if session[:isLaunch].blank?
      if params[:autoSave] == "true"
        nowTime = session[:last_time]
      else
        nowTime = Time.now
        p "redis过期时间再设定"
        $redis.EXPIRE(session[:token], 600)
        p "redis过期时间设定成功"
      end
      if nowTime - session[:last_time] >= 600
        # $logdata.warn(session[:logmsg].msg_get('W_MSG0002', session[:current_user_id]))
        session_clear
        redirect_to("//#{ENV['REPAIRCASE_FQDN']}#{ENV['REPAIRCASE_FQDN_PORT']}/sign_in.html")
        return false
      end

      if params[:autoSave] != "true"
        session[:last_time] = Time.now
        p "redis过期时间再设定"
        $redis.EXPIRE(session[:token], 600)
        p "redis过期时间设定成功"
      end
    end
    return true
  end

  def user_admin_check
    if session[:role] != "0"
      #render html: "invalid operateion"
      render :template => "error/403.html.erb"
    end
  end

  def user_specialist_check
    if session[:role] != "1" && session[:role] != "2"
      #render html: "invalid operateion"
      render :template => "error/403.html.erb"
    end
  end
  def user_common_check
    if session[:role].nil?
#     render html: "invalid operateion"
      render :template => "error/403.html.erb"
    end
  end

  def session_clear
    session[:current_user_id] = nil
    session[:token] = nil
    session[:role] = nil
    session[:last_time] = nil
    session[:tab] = nil
    session[:forbiddenReturn] = nil
    session[:isLaunch] = nil
    #session[:logmsg] = nil
  end

  def cookie_delete
    deleteUserBrowseInfo
  end

  def notice_countget
    if session[:logmsg].nil?
      session[:logmsg] = LogMsg.instance
    end
    begin
      user = UserDetail.find_by_sub_u_id(session[:current_user_id])
      # user = get_user_detail_by_subuid(session[:current_user_id])
      if user.nil?
        raise session[:logmsg].msg_get('E_MSG0002', session[:current_user_id])
      end
      @notice_size = 0
      if session[:role] == '0' || session[:role] == '3'
        notice = Notice.new.noticedata_get_unread(session[:current_user_id])
        if notice.nil?
          raise session[:logmsg].msg_get('E_MSG0018', session[:current_user_id])
        end
        @notice_size = notice.length
      elsif session[:role] == '1' || session[:role] == '2'
        specialist_group = SpecialistGroup.new.specialist_search(session[:current_user_id])
        if specialist_group.nil?
          raise session[:logmsg].msg_get('E_MSG0003', session[:current_user_id])
        end
        notice = Notice.new.noticedata_get_unread(session[:current_user_id], specialist_group[:team_id])
        if notice.nil?
          raise session[:logmsg].msg_get('E_MSG0018', session[:current_user_id])
        end
        @notice_size = notice.length
      end
    rescue Exception => e
      # $logdata.error(e.message)
    end
  end

  def get_carType_and_malfunction
    @car_type = Hash.new
    if self.class.controller_path != "repair_case/search_case"
      MCar.all.order("car_type_name='其他' asc").each do |mcar|
        if @car_type.key?(mcar[:brand_name])
          @car_type[mcar[:brand_name]] << mcar[:car_type_name]
        else
          @car_type[mcar[:brand_name]] = [] << mcar[:car_type_name]
        end
      end
    else
      car_type_data = []
      car_type_data = RepaircasePost.new.car_type_search
      MCar.all.each do |m_car|
        @car_type[m_car[:brand_name]] = []
      end
      car_type_data.each do |mcar|
        if @car_type.key?(mcar['brand'])
          @car_type[mcar['brand']] << mcar['car_type']
        else
          @car_type[mcar['brand']] = [] << mcar['car_type']
        end
      end

    end
    @car_malfunction = Hash.new
    MSymptomRelation.all.each do |msympotomRelation|
      if @car_malfunction.key?(msympotomRelation[:component_name])
          if @car_malfunction[msympotomRelation[:component_name]].key?(msympotomRelation[:symptom_name])
            @car_malfunction[msympotomRelation[:component_name]][msympotomRelation[:symptom_name]] << msympotomRelation[:symptom_detail_name]
          else
            @car_malfunction[msympotomRelation[:component_name]][msympotomRelation[:symptom_name]] = [] << msympotomRelation[:symptom_detail_name]
          end
      else
        symptom = Hash.new
        symptom[msympotomRelation[:symptom_name]] = [] << msympotomRelation[:symptom_detail_name]
        @car_malfunction[msympotomRelation[:component_name]] = symptom
      end
    end
  end

  def get_user_hit
    if session[:logmsg].nil?
      session[:logmsg] = LogMsg.instance
    end
    begin
      ranking_list_tmp = UserHit.select(:user_id, :access_count).order("access_count DESC").limit(5)
      @ranking_list = []
      ranking_list_tmp.each do |user|
        user_info = Hash.new
        user_detail = UserDetail.find_by_sub_u_id(user[:user_id])
        # user_detail = get_user_detail_by_subuid(user[:user_id])
        if user_detail.nil?
          # $logdata.error(session[:logmsg].msg_get('E_MSG0002', user[:user_id]))
        end
        user_info[:access_count] = user[:access_count]
        user_info[:name] = get_user_name(user[:user_id])
        user_info[:user_id] = user[:user_id]

        @ranking_list << user_info
      end
      # $logdata.info(session[:logmsg].msg_get('I_MSG0027'))
    rescue => e
      # $logdata.error(session[:logmsg].msg_get('E_MSG0035'))
      render :template => "error/index.html.erb"
    end
  end

  def author_info(user_id)
    if session[:logmsg].nil?
      session[:logmsg] = LogMsg.instance
    end
    @author_info = {}
    # user_detail = UserDetail.find_by_sub_u_id(user_id)
    user_detail = get_user_detail_by_subuid(user_id)[0]
    puts user_detail.inspect
    if user_detail.nil?
      # $logdata.error(session[:logmsg].msg_get('E_MSG0002', user_id))
    end
    # ??
    # @author_info[:u_id] = user_detail[:u_id]
    @author_info[:u_id] = user_id
    @author_info[:name] = getUserName_by_userDetail(user_detail)

    # user_info = UserInfo.where(" sub_u_id1 = ? or sub_u_id2 = ? or sub_u_id3 = ?", user_id, user_id, user_id)

    @author_info[:u_points_value] = UserDetail.find_by_sub_u_id(user_id).total_accumulated_points_value
    @author_info[:u_pride] = user_detail[:u_pride]
    @author_info[:u_head_portrait_image] = user_detail[:u_head_portrait_image]

    return @author_info
  end

  def has_search_case_permission?
    default_flag = false
    if session[:current_user_id].nil?
      default_flag = true
    end
    if session[:role].present?
      user_role = UserRole.find_by_role_id(session[:role])
      if user_role[:search_status] == "1"
        default_flag = true
      end
    end
    return default_flag
  end

  def has_post_case_permission?
    default_flag = false
    if session[:role].present?
      user_role = UserRole.find_by_role_id(session[:role])
      if user_role[:repaircase_status] == "1"
        default_flag = true
      end
    end
    return default_flag
  end

  # 查看详细权限
  def has_read_case_permission?(repair_case_id = nil)
    if session[:logmsg].nil?
      session[:logmsg] = LogMsg.instance
    end
    default_flag = false
    begin
      if session[:role] == "0" || session[:role] == "1" || session[:role] == "2"
        default_flag = true
      end
      if repair_case_id.present?
         repair_case = RepaircasePost.find_by_repair_case_id(repair_case_id)
         if repair_case.present? && repair_case[:user_id] == session[:current_user_id]
          default_flag = true
         end
      end

      # 根据subid查uid
      user_info = UserInfo.where("sub_u_id1 = ? or sub_u_id2 = ? or sub_u_id3 = ?", session[:current_user_id], session[:current_user_id], session[:current_user_id])

      # user_info = UserInfo.find_by_u_id(session[:current_user_id])
      if user_info.nil?
        session_clear
        redirect_to("//#{ENV['REPAIRCASE_FQDN']}#{ENV['REPAIRCASE_FQDN_PORT']}/sign_in.html")
        raise session[:logmsg].msg_get('E_MSG0002', session[:current_user_id])
      else
        if user_info[0][:payment_status] == 1 && user_info[0][:deadline] > Time.now
          default_flag = true
        end
      end
      if session[:role] == "0" || session[:role] == "1" || session[:role] == "2"
        default_flag = true
      end
      # if session[:role].present? && session[:role] != "4"
      #   user_role = UserRole.find_by_role_id(session[:role])
      #   if user_role.present? &&

      #   else
      #     raise session[:logmsg].msg_get('E_MSG0039', session[:role])
      #   end
      # else
      #   render :template => "error/403.html.erb"
      # end
    rescue Exception => e
      # $logdata.error(e.message)
    end
    return default_flag
  end


  def has_inquery_case_permission?
    default_flag = false
    if session[:role].present?
      user_role = UserRole.find_by_role_id(session[:role])
      if user_role[:inquery_status] == "1"
        default_flag = true
      end
    end
    return default_flag
  end

  def has_expert_approval_permission?
    default_flag = false
    if session[:role].present?
      user_role = UserRole.find_by_role_id(session[:role])
      if user_role[:expert_approval_status] == "1"
        default_flag = true
      end
    end
    return default_flag
  end

  def has_admin_approval_permission?
    default_flag = false
    if session[:role].present?
      begin
        user_role = UserRole.find_by_role_id(session[:role])
        if user_role[:admin_approval_status] == "1"
          default_flag = true
        end
        # if session[:role].present? && session[:role] != "4"
        #   user_role = UserRole.find_by_role_id(session[:role])
        #   if user_role.present? &&

        #   else
        #     raise session[:logmsg].msg_get('E_MSG0039', session[:role])
        #   end
        # else
        #   render :template => "error/403.html.erb"
        # end
      rescue Exception => e
        # $logdata.error(e.message)
      end
    end
    return default_flag
  end

  def isTokenValueExist?(token)
    if session[:logmsg].nil?
      session[:logmsg] = LogMsg.instance
    end
    status = false
    begin

      uri = URI("http://#{ENV['MEMBERSHIP_URL']}/out/getKey?token=" + token)
      res = Net::HTTP.get(uri)
      response = JSON.parse(res)

      if response["code"] == "0" && response["data"].present?
        status = true
      end
    rescue Exception => e
      p "https 接口异常 ======================#{e}"

      # $logdata.error(e.message)
      # $logdata.error(session[:logmsg].msg_get('E_MSG0043',token))
    end
    return status
  end

  def scoreAddOrDelete(user_id, operation, firstRequest=nil)
    if session[:logmsg].nil?
      session[:logmsg] = LogMsg.instance
    end
    firstRequest = true if firstRequest.nil?
    status = false
    token = session[:token]
    #加分接口
    begin
      #加分接口url需要替换
      uri = URI("http://#{ENV['MEMBERSHIP_URL']}/action/points?token=" + token + "&&action_type=" + operation + "&&u_id=" + user_id)
      res = Net::HTTP.get(uri)

      # uri = URI.parse("#{ENV['HTTP_TYPE']}://#{ENV['REPAIRCASE_FQDN']}#{ENV['REPAIRCASE_FQDN_PORT']}/action/points?token=" + token + "&&action_type=" + operation + "&&u_id=" + user_id)
      # http = Net::HTTP.new(uri.host, uri.port)
      # http.use_ssl = true if uri.scheme == "https"
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      # request = Net::HTTP::Get.new(uri.request_uri)
      # # result = http.request(request)
      #result = URI.parse("#{ENV['HTTP_TYPE']}://#{ENV['REPAIRCASE_FQDN']}#{ENV['REPAIRCASE_FQDN_PORT']}/action/points?token=" + token + "&&action_type=" + operation + "&&u_id=" + user_id).read
      response = JSON.parse(res.gsub('\\',''))

      if response["code"] == "0"
        status = true
      end
    rescue Exception => e
      p "https 接口异常 ======================#{e}"

      # $logdata.error(e.message)
    ensure
      #重来
      if firstRequest && !status
        firstRequest = false
        scoreAddOrDelete(user_id, operation, firstRequest)
      else
      if !status
        # $logdata.error(session[:logmsg].msg_get('E_MSG0040', user_id, operation))
      else
        # $logdata.info(session[:logmsg].msg_get('I_MSG0032', user_id, operation))
      end
      end
    end
    return status
  end

  def score_post(user_id, evaluation)
    if evaluation == "A"
      scoreAddOrDelete(user_id, "100")
    elsif evaluation == "B"
      scoreAddOrDelete(user_id, "101")
    else
      scoreAddOrDelete(user_id, "102")
    end
  end

  def score_case_delete(user_id,evaluation)
    if evaluation == "A"
      scoreAddOrDelete(user_id, "103")
    elsif evaluation == "B"
      scoreAddOrDelete(user_id, "104")
    else
      scoreAddOrDelete(user_id, "105")
    end
  end

  def score_login
    #scoreAddOrDelete(session[:current_user_id], 0) if session[:current_user_id].present?
  end

  def score_read
    #scoreAddOrDelete(session[:current_user_id], "1") if session[:current_user_id].present?
  end

  def score_comment
    scoreAddOrDelete(session[:current_user_id], "108") if session[:current_user_id].present?
  end
  def score_comment_delete(user_id)
    scoreAddOrDelete(user_id, "109") if session[:current_user_id].present?
  end

  def score_like
    scoreAddOrDelete(session[:current_user_id], "106") if session[:current_user_id].present?
  end

  def score_like_cancel
    scoreAddOrDelete(session[:current_user_id], "107") if session[:current_user_id].present?
  end

  def score_unlike
    #scoreAddOrDelete(session[:current_user_id], "unlike") if session[:current_user_id].present?
  end

  def score_unlike_cancel
    #scoreAddOrDelete(session[:current_user_id], "unlike_cancel") if session[:current_user_id].present?
  end

  def score_tipoff_handle(user_id)
    scoreAddOrDelete(user_id, "110") if session[:current_user_id].present?
  end

  def score_tipoff_ignore(user_id)
    scoreAddOrDelete(user_id, "111") if session[:current_user_id].present?
  end

  def updateUserBrowseInfo(last_page = nil, user_id = nil, repaircase_id = nil)
    userBrowseInfo = UserBrowseInfo.find_by_current_user_id(session[:current_user_id])
    if userBrowseInfo.nil?
      UserBrowseInfo.create(current_user_id: session[:current_user_id], last_page: last_page, user_id: user_id, repaircase_id: repaircase_id)
    else
      userBrowseInfo.update_attributes!(:last_page => last_page, :user_id => user_id, :repaircase_id => repaircase_id)
    end
  end

  def deleteUserBrowseInfo
    userBrowseInfo = UserBrowseInfo.find_by_current_user_id(session[:current_user_id])
    pp userBrowseInfo
    pp "userBrowseInfo"
    if !userBrowseInfo.nil?
      userBrowseInfo.destroy
    end
  end
end

def getUserName_by_userDetail(user_detail)
  if session[:logmsg].nil?
    session[:logmsg] = LogMsg.instance
  end
  if user_detail.nil?
    # $logdata.error(session[:logmsg].msg_get('E_MSG0037'))
  end
  if user_detail[:public_u_name] == 1
    return user_detail[:u_name]
  else
    return user_detail[:u_nickname]
  end
end

def get_user_name(user_id)
  if session[:logmsg].nil?
    session[:logmsg] = LogMsg.instance
  end
  # user_detail = UserDetail.find_by_sub_u_id(user_id)
  user_detail = get_user_detail_by_subuid(user_id)[0]
  if user_detail.nil?
    # $logdata.error(session[:logmsg].msg_get('E_MSG0002', user_id))
  end
  return getUserName_by_userDetail(user_detail)
end

def get_user_detail_by_subuid(user_id)
  res_user = UserDetail.select('sub_u_id,u_head_portrait_image,
    u_nickname,
    CONVERT(AES_DECRYPT(unhex(u_phone),"aesKey") USING utf8) AS u_phone,
    public_phone,
    CONVERT(AES_DECRYPT(unhex(u_name),"aesKey") USING utf8) AS u_name,
    public_u_name,
    u_years_of_experience,
    public_u_years_of_experience,
    CONVERT(AES_DECRYPT(unhex(u_sex),"aesKey") USING utf8) AS u_sex,
    public_u_sex,
    u_accreditation,
    public_u_accreditation,
    CONVERT(AES_DECRYPT(unhex(u_date_of_birth),"aesKey") USING utf8) AS u_date_of_birth,
    u_pride,
    public_u_pride,
    u_location,
    u_shop_name,
    public_u_shop_name,
    total_accumulated_points_value').where(sub_u_id: user_id)
end