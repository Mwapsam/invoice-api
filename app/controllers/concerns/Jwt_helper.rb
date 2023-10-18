module JwtHelper
    def jwt_key
      Rails.application.secrets.secret_key_base
    end
  
    def issue_token(user)
      exp = 1.hour.from_now.to_i
      payload = { user_id: user.id, exp: exp }
      JWT.encode(payload, jwt_key, 'HS256')
    end    
  
    def decoded_token(token)
      JWT.decode(token, jwt_key, true, { algorithm: 'HS256' })
    rescue JWT::DecodeError
      nil
    end
  
    def user_id(token)
      decoded_token = decoded_token(token)
      if decoded_token && Time.at(decoded_token.first['exp']) > Time.now
        decoded_token.first['user_id']
      end
    end    
end