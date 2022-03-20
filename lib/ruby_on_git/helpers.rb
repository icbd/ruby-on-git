# frozen_string_literal: true

require_relative "./user/committer"
require_relative "./user/author"

module RubyOnGit
  module Helpers
    HASH_ID_LENGTH = 40

    def git_dir
      @git_dir ||=
        if ENV["GIT_DIR"].nil?
          File.expand_path(".git")
        else
          existing_dir! File.expand_path(ENV["GIT_DIR"])
        end
    end

    def git_objects_dir
      @git_objects_dir ||=
        if ENV["GIT_OBJECT_DIRECTORY"].nil?
          File.join(git_dir, "objects")
        else
          existing_dir! File.expand_path(ENV["GIT_OBJECT_DIRECTORY"])
        end
    end

    # Reference: https://git-scm.com/docs/git-commit#_commit_information
    def committer
      name = ENV["GIT_COMMITTER_NAME"] || config["user"]["name"]
      email = ENV["GIT_COMMITTER_EMAIL"] || config["user"]["email"]
      date = ENV["GIT_COMMITTER_DATE"]&.to_datetime || DateTime.now
      Committer.new(name, email, date)
    end

    def author
      name = ENV["GIT_AUTHOR_NAME"] || config["user"]["name"]
      email = ENV["GIT_AUTHOR_EMAIL"] || config["user"]["email"]
      date = ENV["GIT_AUTHOR_DATE"]&.to_datetime || DateTime.now
      Author.new(name, email, date)
    end

    def config
      @config ||= Config.new
    end

    private

    # If the directory does not exist, then create it
    # return the path of dir
    def check_or_create_dir(dir_path)
      FileUtils.mkdir_p(dir_path).first
    end

    def existing_dir!(dir_path)
      return dir_path if Dir.exist?(dir_path)

      raise Error, "Cannot access work tree '#{dir_path}'"
    end
  end
end
