class DiagModule < ActiveRecord::Base #Test为方法名，可自定义
  self.abstract_class = true
  establish_connection :database3 # oracle_development 为database.yml文件中添加的第二个 DB 配置的名字
  # config = ActiveRecord::Base.configurations["database2"] || Rails.application.config.database_configuration["database2"]
  # ActiveRecord::Base.establish_connection(config)
end