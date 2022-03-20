# frozen_string_literal: true

module RubyOnGit
  module TextFileAccessor
    def get
      IO.read file_path
    end

    def set(content)
      IO.write file_path, content
    end

    def file_path
      raise Error, "Should be implemented"
    end
  end
end
