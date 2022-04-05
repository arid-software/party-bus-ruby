module PartyBus
  class Configuration
    attr_accessor :api_key
    attr_accessor :api_url
    attr_accessor :enabled
    attr_accessor :source_id
    attr_accessor :stripped_attributes
    attr_accessor :sub_entity_id

    def initialize
      self.api_key = nil
      self.api_url = "https://party-bus.gigalixirapp.com"
      self.enabled = ENV['RUBY_ENV'] != 'test' && ENV['RAILS_ENV'] != 'test'
      self.source_id = nil
      self.stripped_attributes = []
      self.sub_entity_id = nil
    end
  end
end