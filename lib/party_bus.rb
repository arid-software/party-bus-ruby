require "rubygems"
require "thread"

require "active_support/concern"
require "after_do"
require "httparty"

require "party_bus/version"
require "party_bus/client"
require "party_bus/configuration"
require "party_bus/events/create"
require "party_bus/models/concerns/publishable"

module PartyBus
  LOCK = Mutex.new

  class << self
    def configure(validate_api_key=true)
      yield(configuration) if block_given?
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration ||= PartyBus::Configuration.new }
    end
  end
end
