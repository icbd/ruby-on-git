# frozen_string_literal: true

module Command
  module Commit
    extend ActiveSupport::Concern

    included do
      option :message, desc: "Use the given <msg> as the commit message", aliases: :m
      desc "commit", "Record changes to the repository"
      def commit
        RubyOnGit::Commit.new(message: options[:message]).save
      end
    end
  end
end
