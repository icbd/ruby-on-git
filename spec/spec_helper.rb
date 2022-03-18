# frozen_string_literal: true

require "find"
require "ruby_on_git"
require "tmpdir"
require "zip"

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

def unzip_project(file_path, destination: nil)
  destination ||= File.expand_path(".")
  Zip::File.open(file_path) do |zip_file|
    zip_file.each do |f|
      zip_file.extract(f, File.join(destination, f.name))
    end
  end
end
