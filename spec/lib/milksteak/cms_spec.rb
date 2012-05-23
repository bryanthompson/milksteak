require File.join(File.dirname(__FILE__), "../../spec_helper.rb")

describe Milksteak do
  it "should have milk_root settings" do
    Milksteak::Admin.milk_root.should_not be_nil
  end
  
  context "non-logged-in visitors" do
    it "should redirect to / from /ms-admin" do
      get "/ms-admin"
      last_response.status.should == 302
      get "/ms-admin/"
      last_response.status.should == 302
    end
  end

  context "logged-in users" do
    it "should successfuly render /ms-admin" do
      get "/ms-admin", {}, 'rack.session' => { :ms_user => "bryan-test-user-id" }
      last_response.status.should == 200
    end
  end

end

describe Milksteak::Cms do
  it "should pull list of pages and process routes"
  it "should find and route an existing page with an appropriate route"
end
