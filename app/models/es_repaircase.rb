require 'elasticsearch/model'
require 'json'
class EsRepaircase < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # index名.
  index_name 'repaircase_article'
  document_type 'rc_type'
  def self.create_index
    setting_hash = read_json('_db_docker/es/setting.json')
    # mappingファイル読み込み.
    mapping_hash = read_json('_db_docker/es/mapping.json')
    client = __elasticsearch__.client
    begin
      client.indices.delete index: index_name
    rescue StandardError
      nil
    end
    client.indices.create(index: index_name,
                          body: {
                            setting: setting_hash,
                            mapping: mapping_hash
                          })
  end

  def self.search_es_result(params, searchflg)
    body_query = selectes_by_all(params, searchflg)
    response = __elasticsearch__.search(body_query)
    response
  end

  # 完全匹配数据取得
  def self.selectes_by_all(params, searchflg)
    hashquery = {}
    hashbool = {}
    hashmust = {}
    if params['car_type_flg'].present? && params['car_type_flg']
      hashmust[:must] = car_type_must(params, searchflg)
    else
      hashmust[:must] = component_symptoms(params, searchflg)
    end
    hashbool[:bool] = hashmust
    hashquery[:query] = hashbool
    size = 0
    page = 0
    # 前检索取得最终页件数
    size = params['data_count'] % 8 if params['data_count'].present?
    # 前检索取得页数
    page = params['data_count'] / 8 if params['data_count'].present?
    if params[:page].to_i <= page
      hashquery[:size] = 8
      hashquery[:from] = ((params[:page].to_i < 1 ? 1 : params[:page].to_i) - 1) * 8
    elsif params[:page].to_i == (page + 1)
      hashquery[:size] = 8 - size
    else
      hashquery[:size] = 8
      hashquery[:from] = ((params[:page].to_i < 1 ? 1 : params[:page].to_i) - page -1) * 8 - size
    end
    arraysort = []
    arraysort.push("user_confirmation": { "order": 'desc' })
    hashquery[:sort] = arraysort
    hashquery
  end

  # 系统类别和主要症状
  def self.component_symptoms(params, searchflg)
    array = []
    #品牌
    array.push("match": { "brand": params['brand'] }) if params['brand'].present?
    #系统类别
    array.push("match": { "component": params['component'] }) if params['component'].present?
    #主要症状
    array.push("match": { "symptoms": params['symptoms'] }) if params['symptoms'].present?

    # 关键字
    array.push(should_free_word(params)) if params['free_word'].present?
    if searchflg
      #车名
      array.push("match": { "car_type": params['car_type'] }) if params['car_type'].present?
      #故障码
      array.push(should_malfunction_code(params)) if params['malfunction_code_1'].present?

      #故障频率
      array.push("match": { "frequency": params['frequency'] }) if params['frequency'].present?
      #年份
      array.push("match": { "model_year": params['model_year'] }) if params['model_year'].present?
      #发动机型号
      array.push("match": { "engine_no": params['engine_no'] }) if params['engine_no'].present?
      #行驶里程
      array.push("match": { "mileage": params['mileage'] }) if params['mileage'].present?


    elsif params['frequency_flg'].present? && params['frequency_flg']
      pp params['frequency_flg']
      #车名
      array.push("match": { "car_type": params['car_type'] }) if params['car_type'].present?
      #故障码
      array.push(should_malfunction_code(params)) if params['malfunction_code_1'].present?
      #频率 年份 里程
      array.push(frequency_ng(params)) if params['frequency'].present? || params['model_year'].present? || params['engine_no'].present? || params['mileage'].present?
    elsif !searchflg
      #车名和故障码
      array.push(car_type_ng(params)) if params['car_type'].present? || params['malfunction_code_1'].present?
    end
    array
  end

  # 车名必须场合
  def self.car_type_must(params, searchflg)
    array = []
    #品牌
    array.push("match": { "brand": params['brand'] }) if params['brand'].present?
    #车名
    array.push("match": { "car_type": params['car_type'] }) if params['car_type'].present?

    # 关键字
    array.push(should_free_word(params)) if params['free_word'].present?
    if searchflg

      #故障码
      array.push(should_malfunction_code(params)) if params['malfunction_code_1'].present?
      #故障频率
      array.push("match": { "frequency": params['frequency'] }) if params['frequency'].present?
      #年份
      array.push("match": { "model_year": params['model_year'] }) if params['model_year'].present?
      #年份
      array.push("match": { "engine_no": params['engine_no'] }) if params['engine_no'].present?
      #行驶里程
      array.push("match": { "mileage": params['mileage'] }) if params['mileage'].present?

    elsif params['frequency_flg'].present? && params['frequency_flg']

      #故障码
      array.push(should_malfunction_code(params)) if params['malfunction_code_1'].present?
      #频率 年份 里程
      array.push(frequency_ng(params)) if params['frequency'].present? || params['model_year'].present? || params['engine_no'].present? || params['mileage'].present?
    elsif !searchflg
      #车名和故障码
      array.push(car_type_ng(params)) if params['car_type'].present? || params['malfunction_code_1'].present?
    end
    array
  end

  # def self.check_params(params)
  #   array = keyword_check(params)
  #   array.push(should_free_word(params)) if params['free_word'].present?
  #   #故障码
  #   array.push(should_malfunction_code(params)) if params['malfunction_code_1'].present?

  #   array
  # end

  # def self.check_brand_car_year(params)
  #   array = []
  #   #品牌
  #   array.push("match": { "brand": params['brand'] }) if params['brand'].present?
  #   #车名
  #   array.push("match": { "car_type": params['car_type'] }) if params['car_type'].present?
  #   #年份
  #   array.push("match": { "model_year": params['model_year'] }) if params['model_year'].present?
  #   array
  # end

  # def self.check_mileage(params)
  #   array = check_brand_car_year(params)
  #   #行驶里程
  #   array.push("match": { "mileage": params['mileage'] }) if params['mileage'].present?
  #   array
  # end

  # def self.keyword_check(params)
  #   array = check_mileage(params)

  #   #tab类型
  #   # array.push("match": { "poster_type": params['type'] }) if params['type'].present?
  #   #故障频率
  #   array.push("match": { "frequency": params['frequency'] }) if params['frequency'].present?
  #   #系统类别
  #   array.push("match": { "component": params['component'] }) if params['component'].present?
  #   #主要症状
  #   array.push("match": { "symptoms": params['symptoms'] }) if params['symptoms'].present?
  #   #故障详细描述
  #   array.push("match": { "symptoms_detail": params['symptoms_detail'] }) if params['symptoms_detail'].present?
  #   #其他症状
  #   array.push("match": { "other_symptoms": params['other_symptoms'] }) if params['other_symptoms'].present?

  #   array
  # end

  #其他检索关键字free_word
  def self.should_free_word(params)
    hashfree = {}
    hashshould = {}
    arrayfree = []
    arrayfree.push("match": { "title": params['free_word'] })
    arrayfree.push("match": { "procedure": params['free_word'] })
    arrayfree.push("match": { "other_symptoms": params['free_word'] })
    arrayfree.push("match": { "supplementary": params['free_word'] })
    hashshould[:should] = arrayfree
    hashfree[:bool] = hashshould
    hashfree
  end

  #故障码
  def self.should_malfunction_code(params)
    hashsmc = {}
    hashshould = {}
    arraycode = []
    arraycode.push("term": { "malfunction_code": params['malfunction_code_1'].upcase }) if params['malfunction_code_1'].present?
    arraycode.push("term": { "malfunction_code": params['malfunction_code_2'].upcase }) if params['malfunction_code_2'].present?
    arraycode.push("term": { "malfunction_code": params['malfunction_code_3'].upcase }) if params['malfunction_code_3'].present?
    arraycode.push("term": { "malfunction_code": params['malfunction_code_4'].upcase }) if params['malfunction_code_4'].present?
    arraycode.push("term": { "malfunction_code": params['malfunction_code_5'].upcase }) if params['malfunction_code_5'].present?
    hashshould[:should] = arraycode
    hashsmc[:bool] = hashshould
    hashsmc
  end

  #车名不一样数据抽出
  def self.car_type_ng(params)
    hashsmc = {}
    hashshould = {}
    arraycode = []
    if params['car_type_flg'].present? && params['car_type_flg']
    else
      arraycode.push("match": { "car_type": params['car_type'] }) if params['car_type'].present?
    end
    #故障码
    arraycode.push(should_malfunction_code(params)) if params['malfunction_code_1'].present?
    hashshould[:must] = arraycode
    hashsmc[:bool] = hashshould
    arraynew = []
    arraynew.push(hashsmc)
    hashshouldnew = {}
    hashsmcnew = {}
    hashshouldnew[:must_not] = arraynew
    hashsmcnew[:bool] = hashshouldnew
    hashsmcnew
  end

   #频率 年份 里程至少一个不匹配
   def self.frequency_ng(params)

    hashsmc = {}
    hashshould = {}
    arraycode = []
    arraycode.push("match": { "frequency": params['frequency'] }) if params['frequency'].present?
    arraycode.push("match": { "model_year": params['model_year'] }) if params['model_year'].present?
    arraycode.push("match": { "engine_no": params['engine_no'] }) if params['engine_no'].present?
    arraycode.push("match": { "mileage": params['mileage'] }) if params['mileage'].present?
    hashshould[:must] = arraycode
    hashsmc[:bool] = hashshould
    arraynew = []
    arraynew.push(hashsmc)
    hashshouldnew = {}
    hashsmcnew = {}
    hashshouldnew[:must_not] = arraynew
    hashsmcnew[:bool] = hashshouldnew
    pp hashsmcnew
    hashsmcnew
  end

  private

  # JSON file read.
  def read_json(json_file)
    hash = {}
    File.open(json_file) do |file|
      hash = JSON.parse(file)
    end
    hash
  end
end
