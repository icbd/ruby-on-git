# frozen_string_literal: true

require "thor"
require_relative "./ruby_on_git"

COMMAND_FILES = Dir[File.join(__dir__, "command/*.rb")].sort
COMMAND_FILES.each { |f| require f }

Dir[File.join(__dir__, "command/subcommand/*.rb")].sort.each { |f| require f }

class Cli < Thor
  # include all classes under command folder
  COMMAND_FILES.each do |file|
    class_name = File.basename(file, ".rb").classify
    include "::Command::#{class_name}".constantize
  end

  desc "config [section.key]", "Show config"
  subcommand "config", ::Command::Config
end
