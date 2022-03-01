# frozen_string_literal: true

require_relative "git/version"

module Ruby
  module On
    # Ruby::On::Git
    module Git
      class Error < StandardError; end

      def self.version
        VERSION
      end
    end
  end
end
