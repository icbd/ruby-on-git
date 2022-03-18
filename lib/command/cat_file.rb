# frozen_string_literal: true

module Command
  module CatFile
    extend ActiveSupport::Concern

    included do
      option :p, desc: "Pretty-print the contents of <object> based on its type."
      option :t, desc: "Show the object type identified by <object>."
      option :s, desc: "Show the object size identified by <object>."
      desc "cat-file (-t | -s | -p)", "Provide content or type and size information for repository objects"
      def cat_file
        git_object = RubyOnGit::ObjectBase.new
        git_object.cat_file(options[:t] || options[:s] || options[:p])

        puts(git_object.type) and return if options[:t]
        puts(git_object.size) and return if options[:s]
        git_object.pretty_print and return if options[:p]
      end
    end
  end
end
