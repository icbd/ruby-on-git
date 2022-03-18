# frozen_string_literal: true

require_relative "../helpers"
require "digest"

module RubyOnGit
  class ObjectBase
    include Helpers

    def initialize; end

    def hash_id
      @hash_id ||= Digest::SHA1.hexdigest(frame)
    end

    def type
      @type ||= self.class.name.demodulize.downcase
    end

    def size
      @size ||= encoded_frame_data.bytesize
    end

    def frame
      "#{type} #{size}\0#{encoded_frame_data}"
    end

    def encoded_frame_data
      @encoded_frame_data ||= frame_data.force_encoding(Encoding::ASCII_8BIT)
    end

    def frame_data
      @frame_data ||= (raise Error, "Should be implemented")
    end

    # cat-file -p
    # pretty_print_blob
    # pretty_print_tree
    # pretty_print_commit
    # TODO: Refactor
    def pretty_print
      meth = method("pretty_print_#{type}")
      raise Error, "Type not implemented: #{type}" unless meth

      meth.call
    end

    def save
      before_save
      compressed_data = Zlib::Deflate.deflate(frame, Zlib::BEST_SPEED)

      FileUtils.mkdir object_file_dir unless Dir.exist? object_file_dir
      # TODO: large file may not be written all at once.
      IO.binwrite object_file_path, compressed_data
      after_save
    end

    # Reference: https://git-scm.com/docs/git-cat-file
    def cat_file(hash_id)
      @hash_id = hash_id
      begin
        frame = Zlib::Inflate.inflate IO.binread object_file_path
        type_size, @frame_data = frame.split("\0", 2)
        @type, @size = type_size.split
      rescue StandardError => _e
        raise Error, "invalid object: #{hash_id}"
      end
    end

    def before_save
      # hook implemented in subclass
    end

    def after_save
      # hook implemented in subclass
    end

    def object_file_dir
      File.join git_objects_dir, hash_id[0..1]
    end

    def object_file_path
      File.join object_file_dir, hash_id[2..]
    end

    private

    def pretty_print_blob
      puts frame_data
    end

    def pretty_print_commit
      frame_data.split("\n").each { |line| puts(line) }
    end

    def pretty_print_tree
      byte_idx = 0
      while byte_idx < frame_data.bytesize
        item = frame_data[byte_idx..].unpack("Z*H40")
        auth, type, hash_id, file_name, offset = pretty_print_tree_parse(item)
        puts "#{auth} #{type} #{hash_id}\t#{file_name}"

        byte_idx += offset
      end
    end

    # item: [auth_and_file_name, hash_id]
    def pretty_print_tree_parse(item)
      auth_and_file_name, hash_id = item
      offset = auth_and_file_name.bytesize + 20 + 1 # hash_id (40/2) and \x00
      auth, file_name = auth_and_file_name.split(" ", 2)
      type = auth.start_with?("1") ? "blob" : "tree"
      auth = ("0" * (6 - auth.size)) + auth if auth.size < 6
      [auth, type, hash_id, file_name, offset]
    end
  end
end
