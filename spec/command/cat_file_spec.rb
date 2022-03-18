# frozen_string_literal: true

require "spec_helper"
require "cli"

RSpec.describe "cat-file" do
  hash_ids = {
    commit: "c9124094057256ae74eaae03aea00c51fad5273f",
    tree: "140f8a9be2eec93d74aeaf8663709baef8fc525f",
    blob: "5fbd32667596a1202c3afa42508900eab7072c38"
  }.freeze

  subject do
    Cli.start(["cat-file", param, hash_id])
  end

  before do
    unzip_project(File.expand_path("project-basic.zip", __dir__))
  end

  context "blob object" do
    let(:hash_id) { hash_ids[:blob] }

    context "-t" do
      let(:param) { "-t" }
      it "shows type" do
        expect { subject }.to output("blob\n").to_stdout
      end
    end

    context "-s" do
      let(:param) { "-s" }
      it "shows size" do
        expect { subject }.to output("8\n").to_stdout
      end
    end

    context "-p" do
      let(:param) { "-p" }
      it "pretty prints" do
        expect { subject }.to output("# Desc\n\n").to_stdout
      end
    end
  end

  context "commit object" do
    let(:hash_id) { hash_ids[:commit] }

    context "-t" do
      let(:param) { "-t" }
      it "shows type" do
        expect { subject }.to output("commit\n").to_stdout
      end
    end

    context "-s" do
      let(:param) { "-s" }
      it "shows size" do
        expect { subject }.to output("159\n").to_stdout
      end
    end

    context "-p" do
      let(:param) { "-p" }
      it "pretty prints" do
        text = <<~TEXT
          tree 140f8a9be2eec93d74aeaf8663709baef8fc525f
          author Baodong <wwwicbd@gmail.com> 1647599291 +0800
          committer Baodong <wwwicbd@gmail.com> 1647599291 +0800

          Init
        TEXT

        expect { subject }.to output(text).to_stdout
      end
    end
  end

  context "tree object" do
    let(:hash_id) { hash_ids[:tree] }

    context "-t" do
      let(:param) { "-t" }
      it "shows type" do
        expect { subject }.to output("tree\n").to_stdout
      end
    end

    context "-s" do
      let(:param) { "-s" }
      it "shows size" do
        expect { subject }.to output("67\n").to_stdout
      end
    end

    context "-p" do
      let(:param) { "-p" }
      it "pretty prints" do
        text = <<~TEXT
          040000 tree 4519e32a9b996d77e6e2ef6c5529aaa7dbaf2892\tdoc
          100644 blob a1531841b7c42646318b6bbaca6a516607eef123\treadme.md
        TEXT

        expect { subject }.to output(text).to_stdout
      end
    end
  end
end
