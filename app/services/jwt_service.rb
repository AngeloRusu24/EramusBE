class JwtService
  SECRET_KEY = ENV.fetch('JWT_SECRET_KEY', 'fallback_secret_change_in_production')
  ACCESS_TOKEN_EXPIRY = 15.minutes
  REFRESH_TOKEN_EXPIRY = 7.days

  def self.encode_access(payload)
    payload[:exp] = ACCESS_TOKEN_EXPIRY.from_now.to_i
    payload[:type] = 'access'
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.encode_refresh(payload)
    payload[:exp] = REFRESH_TOKEN_EXPIRY.from_now.to_i
    payload[:type] = 'refresh'
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::DecodeError => e
    raise StandardError, "Token non valido: #{e.message}"
  end
end