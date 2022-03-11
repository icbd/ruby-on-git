# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Support
        module Helpers
          def git_dir
            @git_dir ||=
              if ENV["GIT_DIR"].nil?
                File.expand_path(".git")
              else
                existing_dir! File.expand_path(ENV["GIT_DIR"])
              end
          end

          def git_objects_dir
            @git_objects_dir ||=
              if ENV["GIT_OBJECT_DIRECTORY"].nil?
                File.join(git_dir, "objects")
              else
                existing_dir! File.expand_path(ENV["GIT_OBJECT_DIRECTORY"])
              end
          end

          def head_file_path
            File.expand_path("HEAD", git_dir)
          end

          def head_file
            IO.binread head_file_path
          end

          def head_file=(content)
            IO.binwrite head_file_path, content
          end

          private

          # If the directory does not exist, then create it
          # return the path of dir
          def check_or_create_dir(dir_path)
            FileUtils.mkdir_p(dir_path).first
          end

          def existing_dir!(dir_path)
            return dir_path if Dir.exist?(dir_path)

            raise Error, "Cannot access work tree '#{dir_path}'"
          end
        end
      end
    end
  end
end
