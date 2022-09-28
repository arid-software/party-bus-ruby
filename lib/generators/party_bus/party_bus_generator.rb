require 'rails/generators'

class PartyBusGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :connection_id, required: true, :desc => "required"
  argument :secret, required: true, :desc => "required"

  desc "Configures the party-bus notifier with your application secret"

  def create_initializer_file
    initializer "party_bus.rb" do
      <<-EOF
PartyBus.configure do |config|
  config.connection_id = #{connection_id.inspect}
  config.secret = #{secret.inspect}
end
      EOF
    end
  end
end