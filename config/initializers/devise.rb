Devise.setup do |config|
  config.secret_key = '77e94a6a39a9940959e10a4449b0c15f6a4a89dfc0ec6d177d0036608c76bd4f7080f0e4b3773efb4f9083465af31e54695c418bc9da13176f8a9d0c4e9bd468'
  require 'devise/orm/active_record'
  config.authentication_keys = [ :login ]
  config.strip_whitespace_keys = [ :login ]
  config.password_length = 6..128
  config.stretches = Rails.env.test? ? 1 : 10
  config.sign_out_via = :delete
end
