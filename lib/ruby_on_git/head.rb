# frozen_string_literal: true

require_relative "./helpers"

module RubyOnGit
  # Reference: https://git-scm.com/book/en/v2/Git-Internals-Git-References
  class Head
    include Helpers

    def get
      IO.read file_path
    end

    def set(content)
      IO.write file_path, content
    end

    def file_path
      File.expand_path("HEAD", git_dir)
    end
  end
end
