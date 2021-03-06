# frozen_string_literal: true

require "spec_helper"

RSpec.describe RubyOnGit::Init do
  let(:expected_tree) do
    %w[
      .git
      .git/HEAD
      .git/config
      .git/description
      .git/hooks
      .git/info
      .git/info/exclude
      .git/objects
      .git/objects/info
      .git/objects/pack
      .git/refs
      .git/refs/heads
      .git/refs/tags
    ].freeze
  end

  let(:directory) { nil }

  subject { described_class.new(directory: directory) }

  context "without any ENV variables" do
    context "without directory" do
      it "initializes empty Git repository" do
        subject.perform

        expect(Find.find(".git").to_a.sort).to eq expected_tree
      end
    end

    context "with directory" do
      let(:directory) { "example_dir" }

      context "with existing git repository" do
        let(:existing_head) { "ref: refs/heads/existing\n" }
        before do
          subject.head_file = existing_head
        end

        it "does not overwrite git repository" do
          subject.perform

          expect(subject.head_file_path).to eq File.expand_path(".git/HEAD", directory)
          expect(subject.head_file).to eq existing_head
        end
      end

      context "without existing git repository" do
        it "creates new git repository" do
          subject.perform

          FileUtils.cd File.expand_path(directory)
          expect(Find.find(".git").to_a.sort).to eq expected_tree
        end
      end
    end
  end

  context "with ENV variables" do
    context "with $GIT_DIR and $GIT_OBJECT_DIRECTORY" do
      let(:git_dir) { File.expand_path("example_git_dir") }
      let(:git_object_directory) { File.expand_path("example_git_object_directory") }

      before do
        FileUtils.mkdir_p git_dir
        stub_const("ENV", { "GIT_DIR" => git_dir, "GIT_OBJECT_DIRECTORY" => git_object_directory })
      end

      it "creates new git repository" do
        subject.perform

        expect(subject.head_file.present?).to be_truthy
        expect(subject.send(:git_dir)).to eq git_dir
        expect(subject.send(:git_objects_dir)).to eq git_object_directory
      end
    end

    context "when value of $GIT_DIR is a none-existing directory" do
      let(:git_dir) { File.expand_path("none_existing_dir") }
      before do
        stub_const("ENV", { "GIT_DIR" => git_dir })
      end

      it "throws a Error" do
        expect { subject.perform }.to raise_error(/Cannot access work tree/)
      end
    end

    context "when value of $GIT_OBJECT_DIRECTORY is a none-existing directory" do
      let(:git_object_directory) { File.expand_path("none_existing_dir") }
      before do
        stub_const("ENV", { "GIT_OBJECT_DIRECTORY" => git_object_directory })
      end

      it "creates objects folder and creates new git repository" do
        subject.perform

        expect(subject.head_file.present?).to be_truthy
        expect(subject.send(:git_objects_dir)).to eq git_object_directory
      end
    end
  end
end
