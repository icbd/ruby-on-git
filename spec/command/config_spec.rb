# frozen_string_literal: true

require "spec_helper"
require "cli"

RSpec.describe "config" do
  let(:user_name) { "user_name_for_test" }
  let(:user_git_config_file_path) { File.expand_path("~/.gitconfig") }

  before do
    allow(File).to receive(:open).with(user_git_config_file_path, "r").and_yield StringIO.new <<~TEXT
      [user]
        name = #{user_name}
    TEXT
  end

  context "fetch config" do
    subject do
      Cli.start(["config", param])
    end

    context "config <section.key>" do
      let(:param) { "user.name" }

      it "shows config value" do
        expect { subject }.to output("#{user_name}\n").to_stdout
      end
    end

    context "config <section.invalid_key>" do
      let(:param) { "user.xxx" }

      it "raises Eixt1" do
        expect { subject }.to raise_error(RubyOnGit::Eixt1)
      end
    end

    context "config <section.without_key>" do
      let(:param) { "user" }

      it "shows prompt info and raise Eixt1" do
        expect { subject }.to raise_error(RubyOnGit::Error, "key does not contain a section: user")
      end
    end
  end

  context "list all" do
    subject do
      Cli.start(%w[config list])
    end

    it "lists all config" do
      expect { subject }.to output("user.name = user_name_for_test\n").to_stdout
    end

    # it "list merged and overridden config" do
    #   allow(File).to receive(:file?).with("/etc/gitconfig").and_return true
    #   allow(File).to receive(:open).with("/etc/gitconfig", "r").and_yield StringIO.new <<~TEXT
    #     [user]
    #       name = system_user
    #       email = system@example.com
    #   TEXT
    #
    #   expected_text = <<~TEXT
    #     user.name = system_user
    #     user.email = system@example.com
    #     user.name = #{user_name}
    #   TEXT
    #   expect { subject }.to output(expected_text).to_stdout
    # end
  end
end
