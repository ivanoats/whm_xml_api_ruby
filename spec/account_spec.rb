require File.dirname(__FILE__) + '/spec_helper.rb'
require 'lib/whm'
require 'pp'

describe "A Whm Account that doesn't exist" do
  
  before do
    @server = Whm::Server.new(
      :username => "username",
      :password => "password",
      :host => "dedicated.server.com"
    )
  end
    
  it "should throw an exception when an account doesn't exist" do
    data = open(File.dirname(__FILE__) + '/fixtures/error2.xml').read
    
    @server.expects(:get_xml).with(:url => "accountsummary", :params => {:user=>"doesntexist"}).returns(XmlSimple.xml_in(data, { 'ForceArray' => false }))
    lambda { @server.account("doesntexist")}.should raise_error( Whm::CommandFailedError)
  end
end

describe "Whm Accounts" do
  before do
    @server = Whm::Server.new(
      :username => "username",
      :password => "password",
      :host => "dedicated.server.com"
    )
  end

  it "should find all accounts" do
    data = open(File.dirname(__FILE__) + '/fixtures/listaccts.xml').read    
    @server.expects(:get_xml).returns(XmlSimple.xml_in(data, { 'ForceArray' => false }))    
    
    @server.accounts.length.should == 3
  end
  
  it "should find all accounts when there is only one account" do
    data = open(File.dirname(__FILE__) + '/fixtures/listaccts_single.xml').read    
    @server.expects(:get_xml).returns(XmlSimple.xml_in(data, { 'ForceArray' => false }))    
    @server.accounts.length.should == 1
  end
  
  it "should find an account by name" do
    data = open(File.dirname(__FILE__) + '/fixtures/accountsummary.xml').read    
    @server.expects(:get_xml).with(:url => "accountsummary",:params => {:user=>"magic"}).returns(XmlSimple.xml_in(data, { 'ForceArray' => false }))    
    @server.account("magic").should_not be_nil  
  end
end

describe "A Whm Account" do 
  
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
