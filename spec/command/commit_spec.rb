# frozen_string_literal: true

require "spec_helper"
require "cli"

RSpec.describe "commit" do
  subject do
    Cli.start(["commit", "-m", "First commit"])
  end

  before do
    unzip_project(File.expand_path("project-basic.zip", __dir__))
    FileUtils.mv(".git", ".git_origin")
    Cli.start(["init"])
  end

  it "temp commit" do
    subject
    Dir[".git/objects/*/*"].size
    expect(Dir[".git/objects/*/*"].size).to eq 6

    ref_path = IO.read(File.expand_path(".git/HEAD")).strip.delete_prefix("ref: ")
    expect(File.exist?(".git/#{ref_path}")).to be_truthy
  end
end
