module PartyBus
  class Client
    def self.post(
      entity_id: PartyBus.configuration.entity_id,
      path:,
      body:
    )
      return { success: true } unless PartyBus.configuration.enabled

      response = HTTParty.post(
        "#{PartyBus.configuration.api_url}#{path}",
        body: body.to_json,
        default_timeout: 10,
        headers: headers,
        query: { entity_id: entity_id }
      )

      parse_response(response)
    end

    def self.parse_response(response)
      if response.success?
        {
          success: true,
          serialized_result: response.parsed_response
        }
      else
        {
          success: false,
          errors: [response.parsed_response]
        }
      end
    end

    def self.headers
      {
        'Accept': 'application/json',
        'Authorization': authorization,
        'Content-Type': 'application/json'
      }
    end

    def self.authorization
      "Bearer #{PartyBus.configuration.api_key}"
    end
  end
end
