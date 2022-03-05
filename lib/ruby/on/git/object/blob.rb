# frozen_string_literal: true

module Ruby
  module On
    module Git
      module Object
        class Blob < Base
          attr_reader :content

          def initialize(content)
            super()
            @content = content.to_s.force_encoding(Encoding::ASCII_8BIT)
          end

          def frame
            @frame ||= "blob #{content.bytesize}\0#{content}"
          end
        end
      end
    end
  end
end
