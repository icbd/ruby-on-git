# frozen_string_literal: true

Dir[File.join(__dir__, "git/*.rb")].sort.each { |f| require f }

module Ruby
  module On
    module Git
      class Error < StandardError; end
    end
  end
end
