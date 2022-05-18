module PartyBus
  module Events
    class Create
      def self.perform_using(
        entity_id: PartyBus.configuration.entity_id,
        payload:,
        resource_type:,
        resource_action:,
        source_id: PartyBus.configuration.source_id
      )
        new(entity_id, resource_type, resource_action, payload, source_id).perform
      end

      def initialize(entity_id, resource_type, resource_action, payload, source_id)
        @entity_id = entity_id
        @resource_type = resource_type
        @resource_action = resource_action
        @payload = payload
        @source_id = source_id
      end

      def perform
        @response ||= PartyBus::Client.post(
          entity_id: @entity_id,
          path: '/api/v1/events',
          body: {
            event: {
              payload: @payload,
              resource_type: @resource_type,
              resource_action: @resource_action,
              source_id: @source_id
            }
          }
        )
      end
    end
  end
end