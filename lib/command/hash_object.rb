# frozen_string_literal: true

require "tmpdir"

module Command
  module HashObject
    extend ActiveSupport::Concern

    included do
      option :w, desc: "Actually write the object into the object database."
      option :stdin, desc: "Read the object from standard input instead of from a file."
      option :path, desc: "Hash object as it were located at the given path."
      desc "hash-object [-w] [--path=<file>] [--stdin] <file>",
           "Compute object ID and optionally creates a blob from a file"
      def hash_object(file = nil)
        blob = RubyOnGit::Blob.new(file_path(file, options))
        blob.save if options[:w]
        puts blob.hash_id
      end

      private

      def file_path(file, options)
        file_path = file || options[:path]
        unless file_path.nil?
          file_path = File.expand_path(file_path)
          return file_path if File.exist?(file_path)

          raise RubyOnGit::Error, "File not found: #{file_path}"
        end

        if options[:stdin]
          Dir.mktmpdir do |tmpdir|
            file_path = File.join(tmpdir, "hash_object")
            IO.binwrite file_path, $stdin.read
            return file_path
          end
        end
        help and exit(1)
      end
    end
  end
end