require "httparty"
require "json"

class Kele
  include HTTParty

  def initialize(email, password)
    @base_api_url = "https://www.bloc.io/api/v1"
    response = self.class.post(@base_api_url + "/sessions", body: { "email": email, "password": password })

    raise "Invalid email or password" unless response.code == 200

    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(@base_api_url + '/users/me', headers: { "authorization" => @auth_token })

    raise "Unable to retrieve User Data" unless response.code == 200

    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(@base_api_url + "/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })

    raise "Unable to retrieve mentor's availability" unless response.code == 200

    @mentor_availability = JSON.parse(response.body)
  end
end
