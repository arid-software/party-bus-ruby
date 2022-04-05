module PartyBus
  class Configuration
    attr_accessor :api_key
    attr_accessor :api_url
    attr_accessor :stripped_attributes
    attr_accessor :source_id
    attr_accessor :sub_entity_id

    def initialize
      self.api_key = nil
      self.api_url = "https://party-bus.gigalixirapp.com"
      self.stripped_attributes = []
      self.source_id = nil
      self.sub_entity_id = nil
    end
  end
end