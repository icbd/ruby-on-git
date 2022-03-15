# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Object
        class Blob < Base
          attr_reader :file_path

          def initialize(file_path)
            super()
            @file_path = file_path
          end

          def frame_data
            File.read(file_path)
          end
        end
      end
    end
  end
end
