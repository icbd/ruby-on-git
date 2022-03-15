# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Object
        class Commit < Base
          include Support::Helpers

          def initialize(message: nil)
            super()
            @message = message
          end

          def after_save
            update_ref_heads # TODO: fetch branch name
          end

          def branch_ref_heads_file_path
            ref = head_file.delete_prefix("ref: ").strip
            File.join(git_dir, ref)
          end

          def update_ref_heads
            IO.write branch_ref_heads_file_path, hash_id
          end

          def parent_hash_id
            IO.read(branch_ref_heads_file_path).strip if File.exist?(branch_ref_heads_file_path)
          end

          # use -m "first";
          # if not, read content from .git/COMMIT_EDITMSG;
          # if none, prompt user.
          def message
            @message || commit_edit_msg_content
          end

          def frame_data
            items = [
              "tree #{tree.hash_id}",
              author.to_s,
              committer.to_s,
              "",
              message,
              ""
            ]
            items.insert(1, "parent #{parent_hash_id}") if parent_hash_id
            items.join("\n")
          end

          def tree
            tree = Tree.new(".")
            tree.save
            tree
          end

          def commit_edit_msg_path
            File.join(git_dir, "COMMIT_EDITMSG")
          end

          def commit_edit_msg_content
            IO.read(commit_edit_msg_path) if File.exist?(commit_edit_msg_path)
          end
        end
      end
    end
  end
end
