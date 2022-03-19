# frozen_string_literal: true

require_relative "./object_base"

module RubyOnGit
  class Blob < ObjectBase
    MODE_CODES = {
      file: "100644",
      exe: "100755",
      link: "120000"
    }.freeze

    attr_reader :file_path

    def initialize(file_path)
      super()
      @file_path = file_path
    end

    def frame_data
      File.read(file_path)
    end

    def frame_in_tree
      save # TODO: if not saved
      ["#{file_mode_code} #{File.basename(file_path)}", hash_id].pack("Z*H40") # join by \x00
    end

    private

    def file_mode_code
      return MODE_CODES[:link] if File.symlink?(file_path)

      return MODE_CODES[:exec] if File.executable?(file_path)

      MODE_CODES[:file]
    end
  end
end
