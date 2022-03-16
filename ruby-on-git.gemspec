# frozen_string_literal: true

require_relative "lib/ruby_on_git/version"

Gem::Specification.new do |spec|
  spec.name = "ruby-on-git"
  spec.version = RubyOnGit::VERSION
  spec.authors = ["Baodong"]
  spec.email = ["wwwicbd@gmail.com"]

  spec.summary = "A git client implemented by Ruby."
  spec.description = "This is an experimental project, mainly used to learn the principles of Git."
  spec.homepage = "https://github.com/icbd/ruby-on-git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["README.md", "LICENSE.txt", "exe/**/*", "lib/**/*"]
  spec.bindir = "exe"
  spec.executables << "rgit"
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
