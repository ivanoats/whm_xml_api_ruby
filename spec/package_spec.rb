require File.dirname(__FILE__) + '/spec_helper.rb'
require 'lib/whm'
require 'pp'


describe "Whm Packages" do
  before do
    @server = Whm::Server.new(
      :username => "username",
      :password => "password",
      :host => "dedicated.server.com"
    )
  end

  it "should find all packages" do
    data = open(File.dirname(__FILE__) + '/fixtures/listpkgs.xml').read    
    @server.expects(:get_xml).returns(XmlSimple.xml_in(data, { 'ForceArray' => false }))    
    
    @server.packages.length.should == 3
  end

end

describe "A Whm Package" do 
  
  before do
    @server = Whm::Server.new(
      :username => "username",
      :password => "password",
      :host => "dedicated.server.com"
    )
    data = open(File.dirname(__FILE__) + '/fixtures/accountsummary.xml').read    
    @server.expects(:get_xml).with(:url => "accountsummary", :params => {:user=>"magic"}).returns(XmlSimple.xml_in(data,{ 'ForceArray' => false }))    
    @account = @server.account("magic")
  end
  

  it "should load account attributes" do
    @account.attributes['user'].should == "magic"
    @account.attributes['domain'].should == "magic.example.com"
  end
  
  it "should have a name" do
    @account.name.should == "magic"
    @account.user.should == "magic"
  end
  
  it "should change the password" do
    @server.expects(:change_account_password).returns("new_password")
    @account.password=("new_password").should == "new_password"
  end
  
  it "should suspend an account" do
    @server.expects(:suspend_account).returns("ok")
    @account.suspend!.should == "ok"
  end
  
  it "should unsuspend an account" do
    @server.expects(:unsuspend_account).returns("ok")
    @account.unsuspend!.should == "ok"
  end
  
  it "should terminate an account" do
    @server.expects(:terminate_account).returns("ok")
    @account.terminate!.should == "ok"
  end
  
  it "should change the package on an account" do
    @server.expects(:change_package).returns("ok")
    
    @account.package=("new_package").should == "new_package"
  end
  
  it "should read an attribute" do
    @account.domain.should == 'magic.example.com'
  end
  
  it "should write an attribute" do
    @account.username = 'newname'    
    @account.username.should == 'newname'
  end
  
end
