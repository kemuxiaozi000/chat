# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.middleware.use I18n::JS::Middleware
    I18n.available_locales = %i[ja en zh-CN]
    I18n.enforce_available_locales = true
    I18n.default_locale = :ja

    # エラー出力タグを挿入しない
    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }

    config.assets.paths << config.root.join('node_modules')
    config.assets.paths << config.root.join('node_modules/admin-lte/plugins/iCheck')
    # lib 以下もロードパスに追加
    # config.assets.prefix = "#{ENV['ACCESS_PASS']}/assets"
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
