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
  it "should load a page into params" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/pages/sample_page.yml"), "r")
    f.stub(:save).and_return true
    File.should_receive(:new).with("/tmp/milk_site/pages/home.yml", "r").and_return f
    page = Milksteak::Page.load("home", "r")
    page.should be_a Milksteak::Page
    page.data.should == { "description" => "This is just a test." }
    page.content.should == "This is some test content. {{description}}\n"
  end
  
  it "should write a page with contents in params" do
    f = File.new(File.join(File.dirname(__FILE__), "../fixtures/pages/scratch_page.yml"), "w+")
    File.should_receive(:new).with("/tmp/milk_site/pages/home.yml", "w+").and_return f
    page = Milksteak::Page.write("home", { "description" => "TEST PAGE"}, "TEST CONTENT")
    page.data.should == { "description" => "TEST PAGE" }
    page.content.should == "TEST CONTENT"
    File.unlink(File.join(File.dirname(__FILE__), "../fixtures/pages/scratch_page.yml"))
  end

  it "should render page content" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/pages/sample_page.yml"), "r")
    File.should_receive(:new).with("/tmp/milk_site/pages/home.yml", "r").and_return f
    content = Milksteak::Page.render("home")
    content.should == "<p>This is some test content. This is just a test.</p>"
  end

  it "should return empty string if trying to render a page that doesn't exist" do
    FileUtils.stub(:mkdir).and_return true
    empty = Milksteak::Page.render("home")
    empty.should == ""
  end
  
  it "should accept an empty hash" do
    f = File.new(File.join(File.dirname(__FILE__), "../fixtures/pages/scratch_page.yml"), "w+")
    File.should_receive(:new).with("/tmp/milk_site/pages/home.yml", "w+").and_return f
    page = Milksteak::Page.write("home", {}, "TEST CONTENT")
    page.data.should == {}
    page.content.should == "TEST CONTENT"
    File.unlink(File.join(File.dirname(__FILE__), "../fixtures/pages/scratch_page.yml"))
  end

  it "should raise errors if trying to save without a route variable"
  it "should process a collection variable and find appropriate fragment sets"

end
