# frozen_string_literal: true

module Command
  module Version
    extend ActiveSupport::Concern

    included do
      map %w[-v --version] => :version
      desc "-v, --version", "Show rGit version"
      def version
        puts "rGit version #{RubyOnGit.version}"
      end
    end
  end
end
