# frozen_string_literal: true

require "spec_helper"
require "cli"

RSpec.describe "hash-object" do
  before do
    unzip_project(File.expand_path("project-basic.zip", __dir__))

    allow($stdin).to receive(:read).and_return "Test Content\n\n"
  end

  subject do
    Cli.start(["hash-object", "--stdin", "-w"])
  end

  it "calculates blob hash id and save blob object" do
    expected_file = File.expand_path(".git/objects/4c/cabbc99fdeefbfa56eee40a62f6debf4941820")
    expect(File.exist?(expected_file)).to be_falsey

    expect { subject }.to output("4ccabbc99fdeefbfa56eee40a62f6debf4941820\n").to_stdout
    expect(File.exist?(expected_file)).to be_truthy
  end
end
