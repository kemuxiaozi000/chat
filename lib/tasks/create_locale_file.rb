# frozen_string_literal: true

class CreateLocaleFile
  require 'csv'
  require 'yaml'

  @csv_path = 'config/locales/lupin_language.csv'

  def self.execute
    create_locale_file('ja')
    create_locale_file('zh-CN')
  end

  def self.create_locale_file(language)
    yml_seed = { language => { 'view' => {} } }
    obj = {}
    CSV.foreach(@csv_path, headers: true) do |row|
      next if row['id'].nil?

      obj[row['id']] = row[language] unless row['id'].include?('#')
    end
    yml_seed[language]['view'] = obj

    File.open("config/locales/#{language}.yml", 'w') do |f|
      YAML.dump(yml_seed, f)
    end

    template = File.read("config/locales/i18n_template_#{language}.txt")
    File.open("config/locales/#{language}.yml", 'a') do |f|
      f.write template
    end
  end
end

CreateLocaleFile.execute
