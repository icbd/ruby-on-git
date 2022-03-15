# frozen_string_literal: true

require_relative "./user"

module Ruby
  module On
    module Git
      class Committer < User
        def to_s
          "committer #{super}"
        end
      end
    end
  end
end
