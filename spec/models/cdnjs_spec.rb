require "spec_helper"

# TODO : TAFT
describe Jail::Cdnjs, :vcr do

  describe "#package" do
    let(:jail) { Jail::Cdnjs.find("chosen") }
    
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
    let(:jail) { Jail::Cdnjs.find("chosen") }

    it "it has the pathname of latest version" do
      jail.version_path.to_s.should match(/libs\/chosen\/\d+.\d+.\d+/)
    end
  end

  describe "#files" do
    let(:jail) { Jail::Cdnjs.find("chosen") }

    it "lists the files in #version_path" do
      jail.files.map(&:path).last.should match(/libs\/chosen\/\d+.\d+.\d+/)
    end
    
    it "github API resp listing the (latest) version folder" do
      jail.files.map(&:name).should include("chosen-sprite.png", "chosen.css", "chosen.jquery.js")
    end
  end

  describe "#file(path)" do
    let(:jail) { Jail::Cdnjs.find("chosen") }

    it "it holds the github instance with the path" do
      jail.file("chosen.css").contents.type.should == "file"
    end
  end

  describe "#mapped_files" do
    it "groups files by their extension" do
      pending "Not using this method (FOR DELETION ?)"
      true
    end
  end


end
