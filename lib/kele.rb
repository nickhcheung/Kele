require "httparty"

class Kele
  include HTTParty

  def initialize(email, password)
    @base_api_url = "https://www.bloc.io/api/v1"
    response = self.class.post(@base_api_url + "/sessions", body: { "email": email, "password": password })

    raise "Invalid email or password" unless response.code == 200

    @auth_token = response["auth_token"]
  end
end
