# frozen_string_literal: true

require_relative "./user"

module RubyOnGit
  class Author < User
    def to_s
      "author #{super}"
    end
  end
end
