module PartyBus
  module Events
    class Create
      def self.perform_using(
        connection_id: PartyBus.configuration.connection_id,
        payload:,
        timestamp: Time.now,
        topic:
      )
        new(connection_id, payload, topic, timestamp).perform
      end

      def initialize(connection_id, payload, topic, timestamp)
        @connection_id = connection_id
        @topic = topic
        @payload = payload
        @timestamp = timestamp
      end

      def perform
        @response ||= PartyBus::Client.post(
          body: {
            event: {
              payload: @payload,
              topic: @topic,
            }
          },
          path: "/api/v1/connections/#{@connection_id}/events",
          timestamp: @timestamp
        )
      end
    end
  end
end