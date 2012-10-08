require "spec_helper"

# TODO : TAFT
describe Jail::Github, :vcr do
  
  describe "#github" do
    let(:git) { Jail::Github.find("harvesthq", "chosen") }
    
    it "holds a Github::Client (API v3) instance" do
      git.github.should be_a(Github::Client)
    end
  end

  describe "#where(path)" do
    let(:git) { Jail::Github.find("harvesthq", "chosen") }

    it "sets #path to the arg it's passed" do
      git.where("/chosen")
      git.path.should == "/chosen"
    end

    it "is chainable (returns self)" do
      git.where("/").should == git
    end
  end

  describe "#repos" do
    let(:git) { Jail::Github.find("harvesthq", "chosen") }
    
    it "holds a Github::Repo(API v3) response" do
      git.repos.should be_a(Hashie::Mash)
      git.repos.should respond_to(:owner, :watchers, :full_name, :language)
    end
  end

  describe "#contents" do
    let(:git) { Jail::Github.find("harvesthq", "chosen") }
    
    it "holds a Github::Content (API v3) response" do
      content = git.contents.first
      content.should be_a(Hashie::Mash)
      content.should respond_to(:sha, :path, :name, :type)
    end
  end

  describe "#readme" do
    let(:git) { Jail::Github.find("harvesthq", "chosen") }

    it "returns the readme decoded" do
      git.readme.should match(/Chosen is a library for making/)
    end
  end

  describe "#read" do
    let(:git) { Jail::Github.find("harvesthq", "chosen") }

    it "decodes the base64 of the current content (if it's a file)" do
      git.where("VERSION").read.should match(/\d+.\d+.\d+/)
    end
  end

  describe "#target( type )" do
    let(:git) { Jail::Github.find("harvesthq", "chosen") }

    it "returns a Pathanme" do
      git.where("chosen/chosen.css").target(:js).should == 
        Rails.root.join("vendor/assets/javascripts/chosen.css")
    end
  end

end
