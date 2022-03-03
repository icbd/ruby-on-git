# frozen_string_literal: true

require "active_support/all"
require "thor"
require "byebug" if ENV["GEM_ENV"] == "development"

COMMAND_FILES = Dir[File.join(__dir__, "command/*.rb")].sort
COMMAND_FILES.each { |f| require f }

class Cli < Thor
  # include all classes under command folder
  COMMAND_FILES.each do |file|
    class_name = File.basename(file, ".rb").classify
    include "::Command::#{class_name}".constantize
  end
end
