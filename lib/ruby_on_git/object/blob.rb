# frozen_string_literal: true

require_relative "./object_base"

module RubyOnGit
  class Blob < ObjectBase
    attr_reader :file_path

    def initialize(file_path)
      super()
      @file_path = file_path
    end

    def frame_data
      File.read(file_path)
    end
  end
end
