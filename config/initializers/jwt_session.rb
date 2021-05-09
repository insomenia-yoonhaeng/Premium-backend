JWTSessions.algorithm   = "RS256"
JWTSessions.private_key = OpenSSL::PKey::RSA.generate(2048)
JWTSessions.public_key  = JWTSessions.private_key.public_key
JWTSessions.token_store = :redis, {
  redis_host: "127.0.0.1",
  redis_port: "6379",
  redis_db_name: "0",
  token_prefix: "jwt_"
}
JWTSessions.access_header  = "Authorization"
JWTSessions.access_cookie  = "jwt_access"
JWTSessions.refresh_header = "X-Refresh-Token"
JWTSessions.refresh_cookie = "jwt_refresh"
JWTSessions.csrf_header    = "X-CSRF-Token"
JWTSessions.access_exp_time = 3600 # 1 hour in seconds
JWTSessions.refresh_exp_time = 604800 # 1 week in seconds
# JWTSessions.access_exp_time = 60 # test
# JWTSessions.refresh_exp_time = 180 # test
