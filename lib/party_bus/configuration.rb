module PartyBus
  class Configuration
    attr_accessor :api_key
    attr_accessor :api_url
    attr_accessor :enabled
    attr_accessor :entity_id
    attr_accessor :source_id
    attr_accessor :stripped_attributes

    def initialize
      self.api_key = nil
      self.api_url = "https://party-bus.gigalixirapp.com"
      self.enabled = ENV['RUBY_ENV'] != 'test' && ENV['RAILS_ENV'] != 'test'
      self.entity_id = nil
      self.source_id = nil
      self.stripped_attributes = []
    end
  end
end