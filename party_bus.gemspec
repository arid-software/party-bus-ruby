require_relative 'lib/party_bus/version'

Gem::Specification.new do |spec|
  spec.name          = "party_bus"
  spec.version       = PartyBus::VERSION
  spec.authors       = ["corey jergensen"]
  spec.email         = ["corey@aridsoftware.com"]

  spec.summary       = %q{Get on the PartyBus.}
  spec.description   = %q{This is the gem for PartyBus.}
  spec.homepage      = "https://github.com/arid-software.com/party-bus-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/arid-software/party-bus-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/arid-software/party-bus-ruby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("after_do", '~> 0.4.0')
  spec.add_runtime_dependency("httparty", '~> 0.20.0')
  spec.add_runtime_dependency("activemodel", ">= 6.0")
  spec.add_runtime_dependency("activesupport", ">= 6.0")
end
