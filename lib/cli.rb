# frozen_string_literal: true

require "Thor"

class Cli < Thor
  map %w[-v --version] => :version
  desc "-v, --version", "Show rGit version"
  def version
    puts "rGit version #{Ruby::On::Git.version}"
  end
end
