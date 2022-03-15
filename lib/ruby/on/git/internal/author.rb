# frozen_string_literal: true

require_relative "./user"

module Ruby
  module On
    module Git
      module Internal
        class Author < User
          def to_s
            "author #{super}"
          end
        end
      end
    end
  end
end