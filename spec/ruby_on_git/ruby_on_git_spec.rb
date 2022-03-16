# frozen_string_literal: true

RSpec.describe RubyOnGit do
  it "has a version number" do
    expect(RubyOnGit::VERSION).not_to be nil
    expect(RubyOnGit.version).to eq RubyOnGit::VERSION
  end
end
