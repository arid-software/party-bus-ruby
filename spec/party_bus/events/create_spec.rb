RSpec.describe PartyBus::Events::Create do
  describe "perform_using" do
    attributes = {
      entity_id: SecureRandom.uuid,
      resource_type: 'notification',
      resource_action: 'created',
      payload: {
        foo: :bar
      },
      source_id: SecureRandom.uuid
    }

    it "makes a create event api call" do
      stub_request(:post, "#{PartyBus.configuration.api_url}/api/v1/events")
        .with(
          body: {
            event: {
              resource_type: 'notification',
              resource_action: 'created',
              payload: {
                'foo' => 'bar'
              },
              source_id: attributes[:source_id]
            }
          },
          query: {
            entity_id: attributes[:entity_id]
          }
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
