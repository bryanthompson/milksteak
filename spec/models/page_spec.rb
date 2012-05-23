require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Milksteak::Page do

  it "should raise errors if trying to save without a route variable" do
    File.should_not_receive(:new)
    lambda {
      Milksteak::Page.write("test", {}, "content")
    }.should raise_error Milksteak::NoRouteException
  end
  
  it "should save with a route" do
    f = File.new(File.join(File.dirname(__FILE__), "../fixtures/pages/scratch_page.yml"), "w+")
    File.should_receive(:new).with("/tmp/milk_site/pages/home.yml", "w+").and_return f
    page = Milksteak::Page.write("home", 
                              { "description" => "TEST PAGE", "route" => "/test-page"}, 
                              "TEST CONTENT")
    page.data.should == { "description" => "TEST PAGE", "route" => "/test-page" }
    page.content.should == "TEST CONTENT"
    File.unlink(File.join(File.dirname(__FILE__), "../fixtures/pages/scratch_page.yml"))
  end

end
