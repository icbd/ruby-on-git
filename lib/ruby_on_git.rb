# frozen_string_literal: true

require "active_support/all"
require "zlib"
require "byebug" if ENV["GEM_ENV"] == "development"

Dir[File.join(__dir__, "ruby_on_git/**/*.rb")].sort.each { |f| require f }

module RubyOnGit
  class Eixt1 < StandardError; end

  class Error < StandardError; end

  class GitObjectError < StandardError; end
end
