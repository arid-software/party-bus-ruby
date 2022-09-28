module PartyBus
  module Events
    class Create
      def self.perform_using(
        connection_id:,
        payload:,
        resource_action:,
        resource_type:,
        timestamp: Time.now
      )
        new(connection_id, payload, resource_type, resource_action, timestamp).perform
      end

      def initialize(connection_id, payload, resource_type, resource_action, timestamp)
        @connection_id = connection_id
        @resource_type = resource_type
        @resource_action = resource_action
        @payload = payload
        @timestamp = timestamp
      end

      def perform
        @response ||= PartyBus::Client.post(
          body: {
            event: {
              payload: @payload,
              resource_action: @resource_action,
              resource_type: @resource_type
            }
          },
          path: "/api/v1/connections/#{@connection_id}/events",
          timestamp: @timestamp
        )
      end
    end
  end
end