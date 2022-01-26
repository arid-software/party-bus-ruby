module PartyBus
  module Events
    class Create < PartyBus::Base
      def self.perform_using(resource_type, resource_action, payload)
        new(resource_type, resource_action, payload).perform
      end

      def initialize(resource_type, resource_action, payload)
        @resource_type = resource_type
        @resource_action = resource_action
        @payload = payload
      end

      private

      def response
        @response ||= self.class.post(
          url, body: body.to_json,
          headers: headers
        )
      end

      def url
        base_url + '/events'
      end

      def body
        {
          resource_type: @resource_type,
          resource_action: @resource_action,
          payload: @payload
        }
      end
    end
  end
end