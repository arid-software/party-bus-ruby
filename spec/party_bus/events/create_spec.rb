RSpec.describe PartyBus::Events::Create do
  describe "perform_using" do
    attributes = {
      connection_id: PartyBus.configuration.connection_id,
      resource_type: 'notification',
      resource_action: 'created',
      payload: {
        foo: :bar
      },
    }

    it "makes a create event api call" do
      stub_request(:post, "#{PartyBus.configuration.api_url}/api/v1/connections/#{PartyBus.configuration.connection_id}/events")
        .with(
          body: {
            event: {
              payload: {
                'foo' => 'bar'
              },
              resource_action: 'created',
              resource_type: 'notification'
            }
          },
        )
        .to_return(
          body: {
            success: true
          }.to_json,
          headers: {
            'Content-Type' => 'application/json'
          }
        )

      response = described_class.perform_using(**attributes)

      expect(response[:success]).to be(true)
      expect(response[:serialized_result]).to eq({ 'success' => true })
    end
  end
end
