# frozen_string_literal: true

require "thor"

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

rescue Ruby::On::Git::Error => e
  warn e.message
  exit 1
rescue Errno::EACCES => e
  warn "fatal: #{e.message}"
  exit 1
end
