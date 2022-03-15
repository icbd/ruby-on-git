# frozen_string_literal: true

require_relative "./user"

module Ruby
  module On
    module Git
      module Internal
        class Committer < User
          def to_s
            "committer #{super}"
          end
        end
      end
    end
  end
end
