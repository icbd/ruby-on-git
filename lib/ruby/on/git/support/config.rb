# frozen_string_literal: true

require "inifile"
require_relative "./helpers"

module Ruby
  module On
    module Git
      module Support
        # Reference: https://git-scm.com/docs/git-config#_configuration_file
        # The default behavior is to fetch key by level,
        # if file_path or a specific level is specified, then only this level is fetched.
        class Config
          include Support::Helpers

          GIT_CONFIG_DEFAULT_LEVELS = %w[system global local worktree]

          attr_reader :file_path, :config_level

          def initialize(file_path: nil, config_level: "default")
            @file_path = file_path
            @config_level = config_level
          end

          def [](key)
            git_config_levels.reverse_each do |level|
              current_config = git_config_map[level]
              return current_config[key] if current_config&.has_section?(key)
            end
            {}
          end

          def list
            git_config_union.each do |k, v|
              puts "#{k} = #{v}"
            end
          end

          private

          def default?
            file_path.nil? && config_level == "default"
          end

          # levels that need to be enabled
          def git_config_levels
            return GIT_CONFIG_DEFAULT_LEVELS if default?

            return ["file"] if file_path

            [config_level]
          end

          def git_config_map
            return @git_config_map if instance_variable_defined?("@git_config_map")

            @git_config_map = {}
            git_config_levels.each do |level|
              @git_config_map[level] = IniFile.load(level_options[level])
            end
            @git_config_map
          end

          def git_config_union
            return @git_config_union if instance_variable_defined?("@git_config_union")

            @git_config_union = {}
            git_config_levels.each do |level|
              current_config = git_config_map[level]
              current_config.each do |section, key, value|
                @git_config_union["#{section}.#{key}"] = value
              end
            end
            @git_config_union
          end

          def level_options
            @file_path_options ||=
              {
                "file" => file_path ? File.expand_path(file_path) : "",
                "system" => "/etc/gitconfig",
                "global" => File.expand_path("~/.gitconfig"),
                "local" => File.join(git_dir, "config"),
                "worktree" => File.join(git_dir, "config.worktree")
              }.freeze
          end
        end
      end
    end
  end
end
