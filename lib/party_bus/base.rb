require "httparty"

module PartyBus
  class Base
    include HTTParty
    default_timeout 10 # hard timeout after 10 seconds

    def perform
      return { success: true } unless PartyBus.configuration.enabled

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

    private

    def base_url
      "#{PartyBus.configuration.api_url}/api/v1"
    end

    def headers
      {
        'Authorization': authorization,
        'Content-Type': 'application/json'
      }
    end

    def authorization
      "Bearer #{PartyBus.configuration.api_key}"
    end
  end
end
