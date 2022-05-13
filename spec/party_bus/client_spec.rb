RSpec.describe PartyBus::Client do
  describe "post" do
    it "performs a post request" do
      entity_id = SecureRandom.uuid

      stub_request(:post, "#{PartyBus.configuration.api_url}/test")
        .with(
          body: "{}",
          headers: {
            'Accept' => 'application/json',
            'Authorization' => "Bearer #{PartyBus.configuration.api_key}",
            'Content-Type' => 'application/json'
          },
          query: { entity_id: entity_id }
        )
        .to_return(
          body: '{}',
          headers: {
            'Content-Type' => 'application/json'
          }
        )

      response = described_class.post(
        body: {},
        entity_id: entity_id,
        path: '/test'
      )

      expect(response[:success]).to be(true)
      expect(response[:serialized_result]).to eq({})
    end

    it "does not request when in test mode" do
      entity_id = SecureRandom.uuid

      PartyBus.configure do |config|
        config.enabled = false
      end

      response = described_class.post(
        body: {},
        entity_id: entity_id,
        path: '/test'
      )

      expect(response[:success]).to be(true)

      # TODO: figure out a better way to do this
      PartyBus.configure do |config|
        config.enabled = true
      end
    end
  end
end
