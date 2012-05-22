require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Milksteak do
  it "should get /milksteak" do
    get "/milksteak" 
    last_response.should == 200
  end
  
  
  
end
