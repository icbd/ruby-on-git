# frozen_string_literal: true

module Command
  module Init
    extend ActiveSupport::Concern

    included do
      desc "init [directory]", "Create an empty Git repository or reinitialize an existing one"
      def init(directory = nil)
        Ruby::On::Git::Init.new(directory: directory).perform
      end
    end
  end
end
