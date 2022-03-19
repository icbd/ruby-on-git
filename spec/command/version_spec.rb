# frozen_string_literal: true

require "spec_helper"
require "cli"

RSpec.describe "version" do
  subject do
    Cli.start([param])
  end

  context "--version" do
    let(:param) { "--version" }
    it "shows version" do
      expect { subject }.to output(Regexp.new(Regexp.escape(RubyOnGit::VERSION))).to_stdout
    end
  end

  context "-v" do
    let(:param) { "-v" }
    it "shows version" do
      expect { subject }.to output(Regexp.new(Regexp.escape(RubyOnGit::VERSION))).to_stdout
    end
  end
end
