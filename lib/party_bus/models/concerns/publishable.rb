# frozen_string_literal: true

module Publishable
  extend ActiveSupport::Concern

  included do
    extend AfterDo

    def self.publish_on(*methods)
      # after_commit hook for active record methods
      base_methods = methods.flatten.filter { |m| m.in?([:create, :update, :destroy]) }

      if base_methods.any? && respond_to?(:after_commit)
        after_commit :pb_log_object, on: base_methods
      end

      # after_do hook for other methods
      special_methods = methods.flatten.reject { |m| m.in?([:create, :update, :destroy]) }
      after special_methods do |method_name, *args, _return_val, instance|
        PartyBus::Events::Create.perform_using(**instance.pb_serialize(method_name))
      end
    end

    def pb_log_object(action = nil)
      if respond_to?(:transaction_include_any_action?) && transaction_include_any_action?([:create])
        puts pb_serialize("created", include_changes: false).inspect
      elsif respond_to?(:transaction_include_any_action?) && transaction_include_any_action?([:update])
        puts pb_serialize("updated").inspect
      elsif respond_to?(:transaction_include_any_action?) && transaction_include_any_action?([:destroy])
        puts pb_serialize("destroyed")
      else
        puts pb_serialize(action.to_s)
      end
    end

    # This method is overrideable in case the resource name in party bus differs
    # from the model name. By default we just use the model name.
    def pb_resource_name
      self.class.to_s.underscore
    end

    def pb_serialize(action = nil, include_changes: true)
      payload = {}

      if self.respond_to?(:attributes)
        payload = self.attributes.deep_symbolize_keys.except(*pb_stripped_attrs)

        if include_changes
          changes = self.saved_changes.deep_symbolize_keys.except(*pb_stripped_attrs)

          # Changes are in form of {attribute_name: [current_val, previous_val]}
          changes = changes.transform_values { |val| {previous: val.first, current: val.second} }

          payload = payload.merge(_changes: changes)
        end
      else
        payload = self.instance_values.deep_symbolize_keys.except(*pb_stripped_attrs).merge(_changes: {})
      end

      {
        payload: payload,
        resource_type: pb_resource_name,
        resource_action: action
      }
    end

    # If we've defined #stripped_attrs on the class, pull that list in.
    # Otherwise, just use the defaults.
    #
    # This method is overrideable.
    def pb_stripped_attrs
      if self.respond_to?(:stripped_attributes)
        self.stripped_attributes.concat(pb_default_stripped_attrs)
      else
        pb_default_stripped_attrs
      end
    end

    # These attributes are stripped by default
    def pb_default_stripped_attrs
      [
        :created_at,
        :updated_at,
      ].concat(Rails.application.config.filter_parameters)
    end
  end
end
