require File.join(File.dirname(__FILE__), "../../spec_helper.rb")

describe Milksteak do
  it "should have milk_root and site_id settings" do
    Milksteak::Admin.milk_root.should_not be_nil
    Milksteak::Admin.site_id.should_not be_nil
  end
  
  context "non-logged-in visitors" do
    it "should redirect to / from /ms-admin" do
      get "/ms-admin"
      last_response.status.should == 302
      (last_response.header["Location"] =~ /\/ms\-admin\/login/).should_not be_nil
      get "/ms-admin/"
      last_response.status.should == 302
      (last_response.header["Location"] =~ /\/ms\-admin\/login/).should_not be_nil
    end
    it "should not redirect /ms-admin/login" do
      get "/ms-admin/login"
      last_response.status.should == 200
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
  before :all do
    Milksteak::Cms.class_eval("@@pages").should == []
    Milksteak::Page.should_receive(:list).and_return ["./spec/fixtures/pages/sample_page.yml"]
    f = File.open(File.join(File.dirname(__FILE__), "../../fixtures/pages/sample_page.yml"), "r")
    File.should_receive(:new).with("/tmp/milk_site/pages/sample_page.yml", "r").and_return f
    @a = Milksteak::Cms.new(Sinatra::Application)
    @a.load_pages
  end

  it "should pull list of pages and process routes" do
    pages = Milksteak::Cms.class_eval("@@pages")
    pages.length.should == 1
    pages[0].data["route"].should == "/test-page"
  end

  pending "should find and route an existing page with an appropriate route" do
    page = @a.route("/test-page")
    pages.data["route"].should == "/test-page"
  end
  
  it "should not find a page for a non-existant route"
end
