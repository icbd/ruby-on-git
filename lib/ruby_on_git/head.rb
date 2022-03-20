# frozen_string_literal: true

require_relative "./helpers"

module RubyOnGit
  # Reference: https://git-scm.com/book/en/v2/Git-Internals-Git-References
  class Head
    include Helpers

    def initialize(git_dir: nil)
      @git_dir = git_dir
    end

    def get
      IO.read file_path
    end

    def set(content)
      IO.write file_path, content
    end

    def file_path
      File.expand_path("HEAD", git_dir)
    end

    # init has a separate implementation of `git_dir`
    def git_dir
      @git_dir || super
    end
  end
end
