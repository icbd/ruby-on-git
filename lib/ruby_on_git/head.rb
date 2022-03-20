# frozen_string_literal: true

require_relative "./helpers"
require_relative "./concern/text_file_accessor"
require_relative "./object/object_base"
require_relative "./ref"

module RubyOnGit
  # Reference: https://git-scm.com/book/en/v2/Git-Internals-Git-References
  class Head
    include Helpers
    include TextFileAccessor

    def file_path
      File.join(git_dir, "HEAD")
    end

    def hash_id
      target.hash_id
    end

    def hash_id=(hash_id)
      case target.class
      when ObjectBase
        set hash_id
      when Ref
        target.set hash_id
      end
    end

    private

    def target
      @target ||= begin
        content = get
        if content.start_with?("ref: ")
          Ref.from_head(content)
        elsif content.size == HASH_ID_LENGTH
          ObjectBase.new(content)
        else
          raise Error, "Invalid HEAD with: #{content}"
        end
      end
    end
  end
end
