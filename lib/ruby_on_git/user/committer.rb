# frozen_string_literal: true

require_relative "./user"

module RubyOnGit
  class Committer < User
    def to_s
      "committer #{super}"
    end
  end
end
