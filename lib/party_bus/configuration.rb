module PartyBus
  class Configuration
    attr_accessor :api_url
    attr_accessor :connection_id
    attr_accessor :enabled
    attr_accessor :secret
    attr_accessor :stripped_attributes

    def initialize
      self.api_url = "https://partybus-api.aridsoftware.com"
      self.connection_id = nil
      self.enabled = ENV['RUBY_ENV'] != 'test' && ENV['RAILS_ENV'] != 'test'
      self.secret = nil
      self.stripped_attributes = []
    end
  end
end