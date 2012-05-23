require File.join(File.dirname(__FILE__), "../../spec_helper.rb")

describe Milksteak do
  it "should have milk_root settings" do
    Milksteak::Admin.milk_root.should_not be_nil
  end
  
  it "should get /" do
    get "/milksteak"
    last_response.status.should == 200
  end
end
