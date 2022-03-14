# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Object
        class Tree < Base
          attr_reader :tree_path

          def initialize(tree_path)
            super()
            @tree_path = tree_path
          end

          def frame_data
            items = []
            Dir.glob("*", base: tree_path).each do |item|
              item = File.expand_path(item, tree_path)
              items <<
                if File.directory?(item)
                  dir_frame(item)
                else
                  file_frame(item)
                end
            end
            items.join
          end

          def file_frame(path)
            blob = Blob.where(path)
            ["100644 #{File.basename(path)}", blob.hash_id].pack("Z*H40")
          end

          # TODO: need improve
          def dir_frame(path)
            tree = self.class.new(path)
            ["40000 #{File.basename(path)}", tree.hash_id].pack("Z*H40")
          end
        end
      end
    end
  end
end
