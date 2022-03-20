# frozen_string_literal: true

require_relative "./helpers"
require_relative "./head"

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
module RubyOnGit
  class Init
    include Helpers

    attr_reader :head

    def initialize
      super()

      @head = Head.new
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
      File.exist?(head.file_path)
    end

    private

    def init_files
      init_head
      init_config
      init_description
      init_info_exclude
    end

    def init_git_directories
      check_or_create_dir git_dir
      %w[pack info].each do |dir|
        check_or_create_dir File.expand_path(dir, git_objects_dir)
      end

      %w[hooks info refs/heads refs/tags].each do |dir|
        check_or_create_dir File.expand_path(dir, git_dir)
      end
    end

    def init_head
      head.set "ref: refs/heads/#{default_branch}\n"
    end

    def default_branch
      config["init"]["defaultBranch"] || "master"
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
  end
end
