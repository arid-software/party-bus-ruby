require 'rails/generators'
class PartyBusGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :api_key, required: true, :desc => "required"

  desc "Configures the bugsnag notifier with your API key"

  def create_initializer_file
    initializer "party_bus.rb" do
      <<-EOF
PartyBus.configure do |config|
  config.api_key = #{api_key.inspect}
end
      EOF
    end
  end
end