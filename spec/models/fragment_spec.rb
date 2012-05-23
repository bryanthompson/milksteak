require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Milksteak::Fragment do
  it "should use the fragments/ folder" do
    Milksteak::Fragment.folder.should == "fragments"
  end
end
