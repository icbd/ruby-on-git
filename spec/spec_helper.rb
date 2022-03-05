# frozen_string_literal: true

require "tmpdir"
require "find"
require "active_support/all"
require "ruby/on/git"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around(:each) do |example|
    Dir.mktmpdir do |tmpdir|
      Dir.chdir tmpdir do
        example.run
      end
    end
  end
end
