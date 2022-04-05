module PartyBus
  module Events
    class Create < PartyBus::Base
      def self.perform_using(payload:, resource_type:, resource_action:, source_id:, sub_entity_id:)
        new(resource_type, resource_action, payload, source_id, sub_entity_id).perform
      end

      def initialize(resource_type, resource_action, payload, source_id, sub_entity_id)
        @resource_type = resource_type
        @resource_action = resource_action
        @payload = payload
        @source_id = source_id
        @sub_entity_id = sub_entity_id
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
          event: {
            payload: @payload,
            resource_type: @resource_type,
            resource_action: @resource_action,
            source_id: @source_id,
            sub_entity_id: @sub_entity_id
          }
        }
      end
    end
  end
end