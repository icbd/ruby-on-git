# frozen_string_literal: true

require "active_support/all"
require "byebug" if ENV["GEM_ENV"] == "development"

Dir[File.join(__dir__, "git/**/*.rb")].sort.each { |f| require f }

module Ruby
  module On
    module Git
      class Error < StandardError; end
    end
  end
end
