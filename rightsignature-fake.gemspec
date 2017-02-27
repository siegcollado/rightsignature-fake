# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rightsignature-fake'

Gem::Specification.new do |spec|
  spec.name          = "rightsignature-fake"
  spec.version       = RightSignatureFake::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Sieg Collado"]
  spec.email         = ["siegcollado@gmail.com"]

  spec.summary       = "Fake rightsignature implementation for testing"
  spec.description   = "Fake rightsignature implementation for testing"
  spec.homepage      = "https://github.com/siegcollado/rightsignature-fake"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra", "~> 1"
  spec.add_dependency "webmock"
  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.47.1"
  spec.add_development_dependency "rubocop-rspec", "1.8.0"
  spec.add_development_dependency "rightsignature", "~> 1.0.0"
end
