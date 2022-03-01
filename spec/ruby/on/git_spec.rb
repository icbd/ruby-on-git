# frozen_string_literal: true

RSpec.describe Ruby::On::Git do
  it "has a version number" do
    expect(Ruby::On::Git::VERSION).not_to be nil
    expect(Ruby::On::Git.version).to eq Ruby::On::Git::VERSION
  end
end
