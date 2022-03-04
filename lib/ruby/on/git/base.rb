# frozen_string_literal: true

module Ruby
  module On
    module Git
      class Base
        def initialize
          @git_dir = ENV["GIT_DIR"]
          @git_object_directory = ENV["GIT_OBJECT_DIRECTORY"]
        end

        def git_dir
          return File.expand_path(".git") if @git_dir.nil?

          existing_dir! File.expand_path(@git_dir)
        end

        def git_objects_dir
          return File.join(git_dir, "objects") if @git_object_directory.nil?

          existing_dir! File.expand_path(@git_object_directory)
        end

        def head_file_path
          File.expand_path("HEAD", git_dir)
        end

        def head_file
          IO.read head_file_path
        end

        def head_file=(content)
          IO.write head_file_path, content
        end

        private

        # If the directory does not exist, then create it
        # return the path of dir
        def check_or_create_dir(dir_path)
          FileUtils.mkdir_p(dir_path).first
        end

        def existing_dir!(dir_path)
          return dir_path if Dir.exist?(dir_path)

          throw Error.new("Cannot access work tree '#{dir_path}'")
        end
      end
    end
  end
end
