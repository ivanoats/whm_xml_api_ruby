require File.dirname(__FILE__) + '/spec_helper.rb'
require 'whmxml'
require 'pp'


describe "No Connection" do
  it "should throw an exception" do
    lambda { Whm::Account.find("anything") }.should raise_error( Whm::NoConnection )
  end  
end

describe "A Whm Account that doesn't exist" do
  
  before do
    @xml = Whm::Xml.new('www.example.com',2087,'username','password')
    Whm::Account.xml = @xml
  end
  
  it "should throw an exception when an account doesn't exist" do
    data = open(File.dirname(__FILE__) + '/fixtures/error2.xml').read
    
    @xml.connection.should_receive(:get_xml).with("accountsummary", {:user=>"doesntexist"}).and_return(data)
    lambda { Whm::Account.find("doesntexist")}.should raise_error( Whm::CommandFailed)
  end
end

describe "Whm Accounts" do
  before do
    @xml = Whm::Xml.new('www.example.com',2087,'username','password')
    Whm::Account.xml = @xml
  end

  it "should find all accounts" do
    data = open(File.dirname(__FILE__) + '/fixtures/listaccts.xml').read    
    @xml.connection.should_receive(:get_xml).and_return(data)    
    
    Whm::Account.all.length.should == 3
  end
  
  it "should find an account by name" do
    data = open(File.dirname(__FILE__) + '/fixtures/accountsummary.xml').read    
    @xml.connection.should_receive(:get_xml).with("accountsummary", {:user=>"magic"}).and_return(data)    
    Whm::Account.find("magic").should_not be_nil  
  end

  it "should create an account" do
    account = Whm::Account.new
    
    data = open(File.dirname(__FILE__) + '/fixtures/createacct.xml').read    
    @xml.connection.should_receive(:get_xml).with("createacct", {:username=>"magic"}).and_return(data)    
    Whm::Account.should_receive(:find).and_return(account)    

    Whm::Account.create({:username => "magic"}).should == account
  end
  
  it "should create an account with bad options" do
  end
  
  it "should create an account with default options" do
  end
  
end

describe "A Whm Account" do 
  
  before do
    @xml = Whm::Xml.new('www.example.com',2087,'username','password')
    Whm::Account.xml = @xml
    data = open(File.dirname(__FILE__) + '/fixtures/accountsummary.xml').read    
    @xml.connection.should_receive(:get_xml).with("accountsummary", {:user=>"magic"}).and_return(data)    
    @account = Whm::Account.find("magic")
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
    @xml.should_receive(:change_account_password).and_return("new_password")
    @account.password=("new_password").should == "new_password"
  end
  
  it "should suspend an account" do
    @xml.should_receive(:suspend_account).and_return("ok")
    @account.suspend!.should == "ok"
  end
  
  it "should unsuspend an account" do
    @xml.should_receive(:unsuspend_account).and_return("ok")
    @account.unsuspend!.should == "ok"
  end
  
  it "should terminate an account" do
    @xml.should_receive(:terminate_account).and_return("ok")
    @account.terminate!.should == "ok"
  end
  
  it "should change the package on an account" do
    @xml.should_receive(:change_package).and_return("ok")
    
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
