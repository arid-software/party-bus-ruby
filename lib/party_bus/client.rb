module PartyBus
  class Client
    def self.post(
      body:,
      path:,
      timestamp: Time.now
    )
      return { success: true } unless PartyBus.configuration.enabled

      response = HTTParty.post(
        "#{PartyBus.configuration.api_url}#{path}",
        body: body.to_json,
        default_timeout: 30,
        headers: headers(timestamp, body)
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

    def self.headers(timestamp, body)
      {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Party-Signature': {
          t: timestamp.to_i,
          v1: OpenSSL::HMAC.hexdigest(
            "SHA256",
            PartyBus.configuration.secret,
            "#{timestamp.to_i}.#{body.to_json}"
          )
        }.map { |key| key.join('=') }.join(',')
      }
    end
  end
end
