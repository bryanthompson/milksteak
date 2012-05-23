require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Milksteak::Fragment do
  it "should make the fragment dir if it doesn't exist" do
    File.stub(:exist?).and_return false
    FileUtils.should_receive(:mkdir).twice.and_return true
    Milksteak::Fragment.list.should be_an Array
  end

  it "should get list of fragments from milk_root/fragments" do
    Milksteak::Fragment.list.should be_an Array
  end
 
  # this utility method is used by the read and write methods as a consistent
  # way to access yml fragment documents.   
  it "should load a fragment into params" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/fragments/sample_fragment.yml"), "r")
    f.stub(:save).and_return true
    File.should_receive(:new).with("/tmp/milk_site/fragments/home.yml", "r").and_return f
    fragment = Milksteak::Fragment.load("home", "r")
    fragment.should be_a Milksteak::Fragment
    fragment.data.should == { "description" => "Test Fragment" }
    fragment.content.should == "This is a {{description}}\n"
  end
  
  it "should write a fragment with contents in params" do
    f = File.new(File.join(File.dirname(__FILE__), "../fixtures/fragments/scratch_fragment.yml"), "w+")
    File.should_receive(:new).with("/tmp/milk_site/fragments/home.yml", "w+").and_return f
    fragment = Milksteak::Fragment.write("home", { "description" => "TEST PAGE"}, "TEST CONTENT")
    fragment.data.should == { "description" => "TEST PAGE" }
    fragment.content.should == "TEST CONTENT"
    File.unlink(File.join(File.dirname(__FILE__), "../fixtures/fragments/scratch_fragment.yml"))
  end

  it "should render fragment content" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/fragments/sample_fragment.yml"), "r")
    File.should_receive(:new).with("/tmp/milk_site/fragments/home.yml", "r").and_return f
    content = Milksteak::Fragment.render("home")
    content.should == "<p>This is a Test Fragment</p>"
  end

  it "should return empty string if trying to render a fragment that doesn't exist" do
    FileUtils.stub(:mkdir).and_return true
    empty = Milksteak::Fragment.render("home")
    empty.should == ""
  end
  
  it "should accept an empty hash" do
    f = File.new(File.join(File.dirname(__FILE__), "../fixtures/fragments/scratch_fragment.yml"), "w+")
    File.should_receive(:new).with("/tmp/milk_site/fragments/home.yml", "w+").and_return f
    fragment = Milksteak::Fragment.write("home", {}, "TEST CONTENT")
    fragment.data.should == {}
    fragment.content.should == "TEST CONTENT"
    File.unlink(File.join(File.dirname(__FILE__), "../fixtures/fragments/scratch_fragment.yml"))
  end

  it "should sort fragments by a specified field"
  it "should query fragments by particular field(s)"
end
