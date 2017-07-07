module Roadmap
  def get_roadmap(roadmap_id)
    response = self.class.get(@base_api_url + "/roadmaps/#{roadmap_id}", headers: { "authorization" => @auth_token })

    raise "Unable to retrieve roadmap" unless response.code == 200

    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(@base_api_url + "/checkpoints/#{checkpoint_id}", headers: { "authorization" => @auth_token })

    raise "Unable to retrieve checkpoint" unless response.code == 200

    @checkpoint = JSON.parse(response.body)
  end
end
