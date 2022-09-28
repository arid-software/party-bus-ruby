require "bundler/setup"
require "dotenv"
require "webmock/rspec"
require "party_bus"

Dotenv.load

ActiveRecord::Base.configurations = {
  test: {
    adapter: 'postgresql',
    encoding: 'unicode',
    pool: 1,
    url: ENV['DATABASE_URL']
  }
}
ActiveRecord::Base.establish_connection(:test)
ActiveRecord::Base.logger = Logger.new(STDOUT)

PartyBus.configure do |config|
  config.connection_id = 'b3346fda-bd83-4cd9-8bd8-bb776afae7c0'
  config.secret = '63d0ca21-805c-47f7-b765-f373a34286ab'
  config.enabled = true
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
