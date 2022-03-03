# frozen_string_literal: true

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
      class Init < Base
        attr_reader :directory

        def initialize(directory: ".", **params)
          super(params)

          @directory = directory
        end

        def perform
          init_git_directories
          init_files
        end

        def init_files
          init_head
          init_config
          init_description
        end

        def init_git_directories
          %w[pack info].each do |dir|
            check_or_create_dir File.expand_path(dir, git_objects_dir)
          end

          %w[hooks info/exclude refs/heads refs/tags].each do |dir|
            check_or_create_dir File.expand_path(dir, git_dir)
          end
        end

        def init_head
          file = File.expand_path("HEAD", git_dir)
          content = "ref: refs/heads/master\n"
          IO.write(file, content)
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
          IO.write(file, content)
        end

        def init_description
          file = File.expand_path("description", git_dir)
          content = "Unnamed repository; edit this file 'description' to name the repository.\n"
          IO.write(file, content)
        end

        private

        # `.git` in path of $GIT_DIR is optional.
        # Go out the `.git` at the end, $GIT_DIR should be an existing directory.
        def git_dir
          @__git_dir ||=
            if @git_dir.nil?
              check_or_create_dir File.expand_path(".git", directory)
            else
              existing_dir! @git_dir.delete_suffix(".git")
              check_or_create_dir @git_dir
            end
        end

        def git_objects_dir
          @__git_objects_dir ||=
            if @git_object_directory.nil?
              check_or_create_dir File.expand_path("objects", git_dir)
            else
              check_or_create_dir @git_object_directory
            end
        end
      end
    end
  end
end
