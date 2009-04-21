require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'lib/whm'

describe Whm::Server do 
  before do
    @server = Whm::Server.new(
      :username => "username",
      :password => "password",
      :host => "dedicated.server.com"
    )
  end
  
  it "should build a server object" do
    @server.should_not be_nil
    
    @server.host.should eql("dedicated.server.com")
    @server.username.should eql("username")
    @server.password.should eql("password")
  end
  
  it "should have default options" do
    @server.debug.should eql(false)
    @server.ssl.should eql(true)
    @server.port.should eql(2087)
  end
  
  it "should handle successful commands from cPanel" do
  end
  
  it "should handle unsuccessful commands from cPanel" do
  end
  
  it "should list accounts" do 
    data = open(File.expand_path('spec/fixtures/listaccts.xml')).read
    
    @server.expects(:list_accounts).returns(XmlSimple.xml_in(data))
    @server.list_accounts.eql?(XmlSimple.xml_in(data))
  end
  
  it "should list packages" do
    data = open('spec/fixtures/listpkgs.xml').read
    
    @server.expects(:list_packages).returns(XmlSimple.xml_in(data))
    @server.list_packages.eql?(XmlSimple.xml_in(data))
  end
  
  it "should display the actual server hostname" do
    data = open('spec/fixtures/gethostname.xml').read
    
    @server.expects(:hostname).returns(XmlSimple.xml_in(data)["hostname"])
    @server.hostname.eql?("ns100.example.com")
  end
    
  it "should display the actual server version" do
    data = open('spec/fixtures/version.xml').read
    
    @server.expects(:version).returns(XmlSimple.xml_in(data)["version"])
    @server.version.eql?("11.24.2")
  end
    
  it "should generate ssl certificates" do
    data = open('spec/fixtures/generatessl.xml').read
    
    params = {
      :city => "Houston", 
      :co => "Domain LLC", 
      :cod => "Web", 
      :country => "US", 
      :email => "test@domain.com", 
      :host => "domain.com", 
      :pass => "password",
      :state => "TX", 
      :xemail => "test@domain.com"
    }
    
    @server.expects(:generate_ssl_certificate).with(params).returns(XmlSimple.xml_in(data))
    @server.generate_ssl_certificate(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should display account summaries" do
    data = open('spec/fixtures/accountsummary.xml').read
    
    params = {
      :user => "magic"
    }
    
    @server.expects(:account_summary).with(params).returns(XmlSimple.xml_in(data))
    @server.account_summary(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should change packages" do
    data = open('spec/fixtures/accountsummary.xml').read
    
    params = {
      :user => "user",
      :pkg => "new_plan"
    }
    
    @server.expects(:change_package).with(params).returns(XmlSimple.xml_in(data))
    @server.change_package(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should create accounts" do
    data = open('spec/fixtures/createacct.xml').read
    
    params = {
      :user => "user",
      :domain => "domain.com"
    }
    
    @server.expects(:create_account).with(params).returns(XmlSimple.xml_in(data))
    @server.create_account(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should suspend accounts" do
    data = open('spec/fixtures/suspendacct.xml').read
    
    params = {
      :user => "user",
      :reason => "N/A"
    }
    
    @server.expects(:suspend_account).with(params).returns(XmlSimple.xml_in(data))
    @server.suspend_account(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should unsuspend accounts" do
    data = open('spec/fixtures/unsuspendacct.xml').read
    
    params = {
      :user => "user"
    }
    
    @server.expects(:unsuspend_account).with(params).returns(XmlSimple.xml_in(data))
    @server.unsuspend_account(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should terminate accounts" do
    data = open('spec/fixtures/removeacct.xml').read
    
    params = {
      :user => "user"
    }
    
    @server.expects(:terminate_account).with(params).returns(XmlSimple.xml_in(data))
    @server.terminate_account(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should limit an account's bandwidth usage limit" do
    data = open('spec/fixtures/limitbw.xml').read
    
    params = {
      :user => "username",
      :bwlimit => "1"
    }
    
    @server.expects(:limit_bandwidth_usage).with(params).returns(XmlSimple.xml_in(data))
    @server.limit_bandwidth_usage(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should change account passwords" do
    data = open('spec/fixtures/passwd.xml').read
    
    params = {
      :user => "username",
      :pass => "password"
    }
    
    @server.expects(:change_account_password).with(params).returns(XmlSimple.xml_in(data))
    @server.change_account_password(params).eql?(XmlSimple.xml_in(data))
  end
  
  it "should modify accounts" do
    data = open('spec/fixtures/modifyacct.xml').read
        
    params = {
      :user => "user",
      :domain => "domain.com",
      :HASCGI => 0,
      :CPTHEME => "x3",
      :LANG => "english",
      :MAXPOP => 3,
      :MAXFTP => 0,
      :MAXLST => 1,
      :MAXSUB => 3,
      :MAXPARK => 4,
      :MAXADDON => 5,
      :MAXSQL => 6,
      :shell => 1
    }
    
    @server.expects(:modify_account).with(params).returns(XmlSimple.xml_in(data))
    @server.modify_account(params).eql?(XmlSimple.xml_in(data))
  end
end