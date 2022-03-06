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
            Dir["*"].each do |item|
              # TODO: dir or file
              items << file_frame(File.expand_path(item))
            end
            items.join
          end

          def file_frame(file_path)
            blob = Blob.Where(file_path)
            ["100644 #{File.basename(file_path)}", blob.hash_id].pack("Z*H40")
          end
        end
      end
    end
  end
end
