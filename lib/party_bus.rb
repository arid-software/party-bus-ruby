require "rubygems"
require "thread"
require "httparty"

require "party_bus/version"
require "party_bus/base"
require "party_bus/configuration"
require "party_bus/events/create"

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
