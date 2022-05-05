require "bundler/setup"
require "webmock/rspec"
require "party_bus"

PartyBus.configure do |config|
  config.api_key = 'SFMyNTY.g2gDbQAAACCCkOxgJdqW7C9yes6O5nKzZ8GeV21Q4ZWMrvDxKkCSl24GAH5iyWGAAWIB4TOA.iQU9SWS9rH-JAUZ1HbZrWDgE0DNO9soHdJl-UuHMO_M'
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
