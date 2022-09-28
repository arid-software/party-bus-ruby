RSpec.describe PartyBus::Client do
  describe "post" do
    it "performs a post request" do
      stub_request(:post, "#{PartyBus.configuration.api_url}/test")
        .with(
          body: "{}",
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(
          body: '{}',
          headers: {
            'Content-Type' => 'application/json'
          }
        )

      response = described_class.post(
        timestamp: Time.new(2020, 10, 31, 2, 2, 2),
        body: {},
        path: '/test'
      )

      expect(response[:success]).to be(true)
      expect(response[:serialized_result]).to eq({})
    end

    it "does not request when in test mode" do
      PartyBus.configure do |config|
        config.enabled = false
      end

      response = described_class.post(
        body: {},
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
