# frozen_string_literal: true

require_relative "./object_base"

module RubyOnGit
  class Tree < ObjectBase
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
            frame_in_tree(item)
          else
            Blob.new(item).frame_in_tree
          end
      end
      items.join
    end

    # TODO: need improve
    def frame_in_tree(path)
      tree = self.class.new(path)
      ["40000 #{File.basename(path)}", tree.hash_id].pack("Z*H40") # join by \x00
    end
  end
end
