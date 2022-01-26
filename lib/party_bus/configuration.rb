module PartyBus
  class Configuration
    attr_accessor :api_key
    attr_accessor :api_url

    def initialize
      self.api_key = nil
      self.api_url = "https://party-bus.gigalixirapp.com"
    end
  end
end