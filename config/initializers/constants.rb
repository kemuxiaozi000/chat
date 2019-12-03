# 定義ファイルパス.
file = Rails.root.join('config', 'constants.yml')

# 再帰的にオブジェクトを凍結.
def deep_freeze(hash)
  hash.freeze.each_value do |i|
    i.is_a?(Hash) ? deep_freeze(i) : i.freeze
  end
end

# システム共通定数読み込み.
RC_DEFINE = deep_freeze(YAML.load_file(file)[Rails.env].deep_symbolize_keys)
