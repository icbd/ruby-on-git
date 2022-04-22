# frozen_string_literal: true

require_relative "../atom_lock"

module RubyOnGit
  module TextFileAccessor
    def get
      IO.read file_path
    end

    def set(content)
      # IO.write file_path, content

      AtomLock.with_lock(file_path) do
        content
      end
    end

    def file_path
      raise Error, "Should be implemented"
    end
  end
end
