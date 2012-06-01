require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Milksteak::Fragment do
  it "should use the fragments/ folder" do
    Milksteak::Fragment.folder.should == "fragments"
  end
  
  it "should allow sub-dir fragments" do
    f = File.open(File.join(File.dirname(__FILE__), "../fixtures/objs/sample_obj.yml"), "r")
    f.stub(:save).and_return true
    File.should_receive(:new).with("/tmp/milk_site/fragments/section/sub-folder/fragment-name.yml", "r").and_return f
    c = Milksteak::Fragment.load("section/sub-folder/fragment-name")
  end
  
end
