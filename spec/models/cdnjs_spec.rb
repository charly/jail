require "spec_helper"

# TODO : TAFT
describe Jail::Cdnjs, :vcr do

  let(:jail) { Jail::Cdnjs.find("chosen") }

  describe "#package" do
    it "holds a Hashie of parsed package.json" do
      jail.package.should be_a(Hashie::Mash)
    end

    it "has a name" do
      jail.package.name.should == "chosen"
    end

    it "has a filename" do
      jail.package.filename.should == "chosen.jquery.min.js"      
    end

    it "has a descritpion" do
      jail.package.description.should match(/Chosen is a JavaScript plugin that/)
    end

    it "has a version" do
      jail.package.version.should match( /\d+.\d+.\d+/)
    end
  end

  describe "#version_path" do
    it "returns a Pathname" do
      jail.version_path.should be_a(Pathname)
    end

    it "it has the pathname of latest version" do
      jail.version_path.to_s.should match(/libs\/chosen\/\d+.\d+.\d+/)
    end
  end

  describe "#version_files" do
    it "lists the files in #version_path" do
      jail.version_files.map(&:path).last.should match(/libs\/chosen\/\d+.\d+.\d+/)
    end
    
    it "github API resp listing the (latest) version folder" do
      jail.version_files.map(&:name).should include("chosen-sprite.png", "chosen.css", "chosen.jquery.js")
    end
  end

  describe "#file(path)" do
    it "it holds the github instance with the path" do
      path = jail.version_path.join("chosen.css")
      jail.file(path).contents.type.should == "file"
    end
  end

  describe "#tree" do
    let(:jail) { Jail::Cdnjs.find("twitter-bootstrap") }

    it "returns an Array of Hashie::Mash" do
      jail.tree.first.should be_a(Hashie::Mash)
    end

    it "returns a bucket of nested leaves" do
      jail.tree.select {|t| Pathname(t.path).parent.basename.to_s == "css"}.
        map(&:name).should include("bootstrap.css", "bootstrap-responsive.css")
    end
  end

  describe "#mapped_files" do
    it "groups files by their extension" do
      pending "Not using this method (FOR DELETION ?)"
      true
    end
  end

end
