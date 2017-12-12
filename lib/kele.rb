require 'httparty'

class Kele

  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @user_auth_code = self.class.post("/sessions", body: { "email": email, "password": password })
    puts @user_auth_code.code
    raise 'Invalid email or password' if @user_auth_code.code != 200
  end
end
