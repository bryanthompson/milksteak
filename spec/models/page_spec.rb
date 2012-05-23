require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Milksteak::Page do
  it "should make the page dir if it doesn't exist" do
    File.stub(:exist?).and_return false
    FileUtils.should_receive(:mkdir).twice.and_return true
    Milksteak::Page.list.should be_an Array
  end

  it "should get list of pages from milk_root/pages" do
    Milksteak::Page.list.should be_an Array
  end
 
  # this utility method is used by the read and write methods as a consistent
  # way to access yml page documents.   
  it "should load a new page" do
    f = File.new("/tmp/page_file", "r")
    f.stub(:save).and_return true
    File.should_receive(:new).with("/tmp/milk_site/pages/home.yml", "r").and_return f
    page = Milksteak::Page.load("home", "r")
    page.should be_a Milksteak::Page
    page.data.should be_a Hash
    page.content.should == ""
  end
  
  it "should read a page into parsed params" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/pages/sample_page.yml"), "r")
    f.stub(:save).and_return true
    
  end

  it "should write a page with contents in params"

  it "should route pages using middleware"
end
