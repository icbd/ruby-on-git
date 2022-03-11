# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Object
        class Blob < Base
          attr_reader :file_text

          def initialize(file_text)
            super()
            @file_text = file_text
          end

          def self.where(file_path)
            new File.read(file_path)
          end

          def frame_data
            file_text
          end
        end
      end
    end
  end
end
