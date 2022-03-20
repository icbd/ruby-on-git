# frozen_string_literal: true

require_relative "./helpers"
require_relative "./concern/text_file_accessor"

module RubyOnGit
  # Reference: https://git-scm.com/book/en/v2/Git-Internals-Git-References
  class Ref
    include Helpers
    include TextFileAccessor

    TYPES = %w[heads tags remotes].freeze

    attr_reader :type, :name

    def initialize(type:, name:)
      raise Error, "Type not supported: #{type}" unless TYPES.include?(type)

      @type = type
      @name = name
    end

    # "ref: refs/heads/existing\n"
    def self.from_head(ref_content)
      _, type, name = ref_content.delete_prefix("ref: ").split("/")
      new(type: type, name: name)
    end

    def file_path
      File.join(git_dir, type, name)
    end

    def hash_id
      get
    end
  end
end
