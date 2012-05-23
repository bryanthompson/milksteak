require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestYmlObject < Milksteak::YmlContent
  def self.folder; "objs"; end
end

describe TestYmlObject do

  it "should make the obj dir if it doesn't exist" do
    File.stub(:exist?).and_return false
    FileUtils.should_receive(:mkdir).twice.and_return true
    TestYmlObject.list.should be_an Array
  end

  it "should get list of objs from milk_root/objs" do
    TestYmlObject.list.should be_an Array
  end
 
  # this utility method is used by the read and write methods as a consistent
  # way to access yml obj documents.   
  it "should load a obj into params" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/objs/sample_obj.yml"), "r")
    f.stub(:save).and_return true
    File.should_receive(:new).with("/tmp/milk_site/objs/home.yml", "r").and_return f
    obj = TestYmlObject.load("home", "r")
    obj.should be_a TestYmlObject
    obj.data.should == { "description" => "Test Object" }
    obj.content.should == "This is a {{description}}\n"
  end
  
  it "should write a obj with contents in params" do
    f = File.new(File.join(File.dirname(__FILE__), "../fixtures/objs/scratch_obj.yml"), "w+")
    File.should_receive(:new).with("/tmp/milk_site/objs/home.yml", "w+").and_return f
    obj = TestYmlObject.write("home", { "description" => "TEST PAGE"}, "TEST CONTENT")
    obj.data.should == { "description" => "TEST PAGE" }
    obj.content.should == "TEST CONTENT"
    File.unlink(File.join(File.dirname(__FILE__), "../fixtures/objs/scratch_obj.yml"))
  end

  it "should render obj content" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/objs/sample_obj.yml"), "r")
    File.should_receive(:new).with("/tmp/milk_site/objs/home.yml", "r").and_return f
    content = TestYmlObject.render("home")
    content.should == "<p>This is a Test Object</p>"
  end

  it "should return empty string if trying to render a obj that doesn't exist" do
    FileUtils.stub(:mkdir).and_return true
    empty = TestYmlObject.render("home")
    empty.should == ""
  end
  
  it "should accept an empty hash" do
    f = File.new(File.join(File.dirname(__FILE__), "../fixtures/objs/scratch_obj.yml"), "w+")
    File.should_receive(:new).with("/tmp/milk_site/objs/home.yml", "w+").and_return f
    obj = TestYmlObject.write("home", {}, "TEST CONTENT")
    obj.data.should == {}
    obj.content.should == "TEST CONTENT"
    File.unlink(File.join(File.dirname(__FILE__), "../fixtures/objs/scratch_obj.yml"))
  end

end
