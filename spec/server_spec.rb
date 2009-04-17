require File.dirname(__FILE__) + '/spec_helper.rb'
require 'whmxml'
require 'pp'

describe "A WHM Server" do 
  
  before do
    @xml = Whm::Xml.new(
      :username => "username",
      :password => "password",
      :host => "www.example.com"
    )
  end
  
  it "should list accounts" do 
    data = open('fixtures/listaccts.xml').read
    @xml.should_receive(:get_xml).with({:url=>"listaccts", :params=>{}}).and_return(XmlSimple.xml_in(data))
    @xml.list_accounts.should_not be_nil
  end
  
  it "should list packages" do
    data = open('fixtures/listpkgs.xml').read
    @xml.should_receive(:get_xml).with(:url => 'listpkgs').and_return(XmlSimple.xml_in(data))
    @xml.list_packages.should_not be_nil
  end
  
  it "should display hostname" do
    data = open(File.dirname(__FILE__) + '/fixtures/gethostname.xml').read
    @xml.should_receive(:get_xml).with('gethostname').and_return(XmlSimple.xml_in(data))
    @xml.hostname.should_not be_nil
  end
  
  it "should display version" do
    data = open(File.dirname(__FILE__) + '/fixtures/version.xml').read
    @xml.should_receive(:get_xml).with('version').and_return(XmlSimple.xml_in(data))
    @xml.version.should_not be_nil
  end
  
  it "should generate a ssl certificate" do
    data = open(File.dirname(__FILE__) + '/fixtures/generatessl.xml').read
    @xml.should_receive(:get_xml).with('generatessl',{}).and_return(XmlSimple.xml_in(data))
    @xml.generate_certificate.should_not be_nil
  end
  
  it "should generate a ssl certificate using an alias" do
    data = open(File.dirname(__FILE__) + '/fixtures/generatessl.xml').read
    @xml.should_receive(:get_xml).with('generatessl',{:xemail => "xemail"}).and_return(XmlSimple.xml_in(data))
    @xml.generate_ssl_certificate({:xemail => "xemail"}).should_not be_nil
  end
  
  describe "working with Accounts" do
    before do
      @account_options = {:username => 'test_account'}
    end
    
    it "should create an account" do
      data = open(File.dirname(__FILE__) + '/fixtures/createacct.xml').read
      @xml.should_receive(:get_xml).with('createacct',@account_options).and_return(XmlSimple.xml_in(data))
      @xml.create_account(@account_options).should_not be_nil
    end
    
    it "should change account password" do
      data = open(File.dirname(__FILE__) + '/fixtures/passwd.xml').read
      @xml.should_receive(:get_xml).with('passwd',{:user => 'test_account', :pass => 'new_password'}).and_return(XmlSimple.xml_in(data))
      @xml.change_account_password('test_account', 'new_password').should_not be_nil
    end
    
    it "should limit bandwidth usage" do
      data = open(File.dirname(__FILE__) + '/fixtures/limitbw.xml').read
      @xml.should_receive(:get_xml).with('limitbw',{:user => 'test_account', :bwlimit => '100'}).and_return(XmlSimple.xml_in(data))
      @xml.limit_bandwidth('test_account', '100').should_not be_nil
    end
    
    it "should display account summary" do
      data = open(File.dirname(__FILE__) + '/fixtures/accountsummary.xml').read
      @xml.should_receive(:get_xml).with('accountsummary',{:user =>'test_account'}).and_return(XmlSimple.xml_in(data))
      @xml.account_summary('test_account').should_not be_nil
    end
    
    it "should suspend account" do
      data = open(File.dirname(__FILE__) + '/fixtures/suspendacct.xml').read
      @xml.should_receive(:get_xml).with('suspendacct',{:user =>'test_account', :reason => 'General Misbehaving'}).and_return(XmlSimple.xml_in(data))
      @xml.suspend_account('test_account', 'General Misbehaving').should_not be_nil
    end

    it "should unsuspend account" do
      data = open(File.dirname(__FILE__) + '/fixtures/unsuspendacct.xml').read
      @xml.should_receive(:get_xml).with('unsuspendacct',{:user =>'test_account'}).and_return(XmlSimple.xml_in(data))
      @xml.unsuspend_account('test_account').should_not be_nil
    end

    it "should terminate account" do
      data = open(File.dirname(__FILE__) + '/fixtures/removeacct.xml').read
      @xml.should_receive(:get_xml).with('removeacct',{:user =>'test_account', :keepdns => 'n'}).and_return(XmlSimple.xml_in(data))
      @xml.terminate_account('test_account').should_not be_nil
    end
    
    it "should change account package" do
      data = open(File.dirname(__FILE__) + '/fixtures/changepackage.xml').read
      @xml.should_receive(:get_xml).with('changepackage',{:user =>'test_account', :pkg => 'new_package'}).and_return(XmlSimple.xml_in(data))
      @xml.change_package('test_account', 'new_package').should_not be_nil
    end
    
    it "should display an error message" do
      data = open(File.dirname(__FILE__) + '/fixtures/error.xml').read
      @xml.connection.should_receive(:get_xml).with('listaccts',{}).and_return(data)
      
      lambda { @xml.list_accounts }.should raise_error( Whm::CommandFailed )
    end

    it "should throw an exception when an account doesn't exist" do
      data = open(File.dirname(__FILE__) + '/fixtures/error2.xml').read
      @xml.connection.should_receive(:get_xml).with('accountsummary',{:user => 'bad_account'}).and_return(data)
      lambda { @xml.account_summary('bad_account') }.should raise_error( Whm::CommandFailed )
    end

  end
end

describe "A Nonexistant Server" do 
  before do
    @xml = Whm::Xml.new('localhost',2087,'username','password')
  end
  
  it "should exceptionize on connection failure" do
    lambda { @xml.version }.should raise_error( Whm::CantConnect )
  end
end