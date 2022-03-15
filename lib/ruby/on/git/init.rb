# frozen_string_literal: true

require_relative "./helpers"

# .git
# ├── HEAD
# ├── config
# ├── description
# ├── hooks
# ├── info
# │   └── exclude
# ├── objects
# │   ├── info
# │   └── pack
# └── refs
#     ├── heads
#     └── tags
module Ruby
  module On
    module Git
      class Init
        include Helpers

        attr_reader :directory

        def initialize(directory: ".")
          super()

          @directory = directory
        end

        def perform
          if repo_existing?
            puts "Git repository already exists.\n"
          else
            init_git_directories
            init_files
            puts "Initialized empty Git repository in #{git_dir}\n"
          end
        end

        def repo_existing?
          File.exist?(head_file_path)
        end

        private

        def init_files
          init_head
          init_config
          init_description
          init_info_exclude
        end

        def init_git_directories
          %w[pack info].each do |dir|
            check_or_create_dir File.expand_path(dir, git_objects_dir)
          end

          %w[hooks info refs/heads refs/tags].each do |dir|
            check_or_create_dir File.expand_path(dir, git_dir)
          end
        end

        def init_head
          self.head_file = "ref: refs/heads/master\n"
        end

        def init_config
          file = File.expand_path("config", git_dir)
          content = <<~TEXT
            [core]
            	repositoryformatversion = 0
            	filemode = true
            	bare = false
            	logallrefupdates = true
            	ignorecase = true
            	precomposeunicode = true

          TEXT
          IO.binwrite(file, content)
        end

        def init_description
          file = File.expand_path("description", git_dir)
          content = "Unnamed repository; edit this file 'description' to name the repository.\n"
          IO.binwrite(file, content)
        end

        def init_info_exclude
          file = File.join(git_dir, "info", "exclude")
          content = <<~TEXT
            .DS_Store
            .byebug_history
            /**/.idea/*
          TEXT
          IO.binwrite(file, content)
        end

        # `.git` in path of $GIT_DIR is optional.
        # Go out the `.git` at the end, $GIT_DIR should be an existing directory.
        def git_dir
          @__git_dir ||=
            if ENV["GIT_DIR"].nil?
              check_or_create_dir File.expand_path(".git", directory)
            else
              existing_dir! ENV["GIT_DIR"].delete_suffix(".git")
              check_or_create_dir ENV["GIT_DIR"]
            end
        end

        def git_objects_dir
          @__git_objects_dir ||=
            if ENV["GIT_OBJECT_DIRECTORY"]
              check_or_create_dir ENV["GIT_OBJECT_DIRECTORY"]
            else
              check_or_create_dir File.expand_path("objects", git_dir)
            end
        end
      end
    end
  end
end
