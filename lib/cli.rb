# frozen_string_literal: true

require "active_support/all"
require "thor"

Dir[File.join(__dir__, "command/*.rb")].sort.each { |f| require f }

class Cli < Thor
  include ::Command::Version
end
