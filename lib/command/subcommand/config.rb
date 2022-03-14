# frozen_string_literal: true

require "thor"
require_relative "../../ruby/on/git/support/config"

module Command
  class Config < Thor
    map %w[-l --list] => :list
    option :file, desc: "use given config file"
    option :system, type: :boolean, desc: "use global config file"
    option :global, type: :boolean
    option :local, type: :boolean
    option :worktree, type: :boolean
    option :list, type: :boolean, desc: "list all"
    desc "config --list", "List all variables set in config file, along with their values."
    def list
      Ruby::On::Git::Support::Config
        .new(file_path: options[:file], config_level: config_level)
        .list
    end

    default_command(:fetch)
    option :file, desc: "use given config file"
    option :system, type: :boolean, desc: "use global config file"
    option :global, type: :boolean
    option :local, type: :boolean
    option :worktree, type: :boolean
    desc "config <key>", "Get the value for a given key. Returns error code 1 if the key was not found."
    def fetch(key = nil)
      config = Ruby::On::Git::Support::Config
        .new(file_path: options[:file], config_level: config_level)
      section, key = key.to_s.split(".")
      if section.nil? || key.nil?
        help
        exit(1)
      end

      raise Ruby::On::Git::Error, "key does not contain a section: #{section}" if key.nil?
      val = config[section][key]
      puts val
      exit(1) if val.nil?
    end

    private

    def config_level
      Ruby::On::Git::Support::Config::GIT_CONFIG_DEFAULT_LEVELS.each do |level|
        return level if options[level]
      end
      "default"
    end
  end
end