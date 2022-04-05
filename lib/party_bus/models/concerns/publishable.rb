# frozen_string_literal: true

require "after_do"

module Publishable
  extend ActiveSupport::Concern

  included do
    extend AfterDo

    def self.publish_on(*methods)
      # after_commit hook for active record methods
      after_commit :pb_after_create, on: :create if methods.flatten.include?(:create)
      after_commit :pb_after_update, on: :update if methods.flatten.include?(:update)
      after_commit :pb_after_destroy, on: :destroy if methods.flatten.include?(:destroy)

      # after_do hook for other methods
      special_methods = methods.flatten.reject { |m| m.in?([:create, :update, :destroy]) }
      if special_methods.any?
        after special_methods do |method_name, *args, _return_val, instance|
          pb_create_event(**instance.pb_serialize(method_name))
        end
      end
    end

    def pb_after_create
      self.class.pb_create_event(**pb_serialize("created"))
    end

    def pb_after_update
      self.class.pb_create_event(**pb_serialize("updated"))
    end

    def pb_after_destroy
      self.class.pb_create_event(**pb_serialize("destroyed"))
    end

    def self.pb_create_event(attributes)
      PartyBus::Events::Create.perform_using(**attributes)
    end

    # This method is overrideable in case the resource name in party bus differs
    # from the model name. By default we just use the model name.
    def pb_resource_name
      self.class.to_s
    end

    def pb_serialize(action = nil)
      payload = if self.respond_to?(:attributes)
        self.attributes.deep_symbolize_keys.except(*pb_stripped_attributes)
      else
        self.instance_values.deep_symbolize_keys.except(*pb_stripped_attributes)
      end

      {
        payload: payload,
        resource_type: pb_resource_name,
        resource_action: action,
        source_id: pb_source_id,
        sub_entity_id: pb_sub_entity_id
      }
    end

    # These attributes are stripped by default
    def pb_stripped_attributes
      PartyBus.configuration.stripped_attributes
    end

    def pb_source_id
      PartyBus.configuration.source_id
    end

    def pb_sub_entity_id
      PartyBus.configuration.sub_entity_id
    end
  end
end
