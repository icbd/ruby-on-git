# frozen_string_literal: true

require "spec_helper"

RSpec.describe RubyOnGit::AtomLock do
  context ".with_lock" do
    let(:target_file) { File.expand_path(".git/HEAD") }
    let(:lock_file) { File.expand_path(".git/.lock") }
    let(:content) { "ref: refs/heads/default_branch" }

    before do
      FileUtils.mkdir_p(".git")
    end

    subject(:with_lock) do
      described_class.with_lock(target_file) do
        content
      end
    end

    context "when there is no concurrent contention" do
      it "creates a new lock file and writes content and closes it" do
        with_lock
        expect(File.read(target_file)).to eq content
      end
    end

    context "when there is concurrent contention" do
      it "raise error" do
        # FileUtils.touch(lock_file)
        File.open(lock_file, described_class::LOCK_FILE_FLAG) do
          expect { with_lock }.to raise_error described_class::StaleLock
        end
      end
    end
  end
end
