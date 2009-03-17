# This is WHM_XML.rb
# It has the class WhmXml
# It is used for controlling WHM, which is a way of automating web hosting
# acccount setup, password resets, and other web hosting account info
# Copyright (C) 2008 Ivan Storck
# MIT License (see README.txt)

module Whm
  VERSION = '0.2.0'
  require 'rubygems'
  require 'net/https'
  require 'hpricot'
  require 'uri'
  
  class CantConnect < StandardError; end
  class NoConnection < StandardError; end
  class CommandFailed < StandardError; end
  
  class Account
    
    attr_accessor :attributes
    attr_accessor :writable_attributes
    
    class << self
      attr_accessor :xml
    end
    
    #TODO make this not goofy
    @@default_attributes = {}
    @@writable_attributes = %w(username domain plan pkgname savepkg featurelist quota password ip cgi frontpage hasshell contactemail cpmod maxftp maxsql maxpop maxlst maxsub maxpark maxaddon bwlimit customip language useregns hasuseregns reseller)
    @@readonly_attributes = %w(disklimit diskused email ip owner partition plan startdate suspended suspendreason theme unix_startdate user)
    
    def self.all
      raise NoConnection unless @xml
      summary = @xml.list_accounts
      
      accounts = []
      summary.search('acct').each do |acct|
        account = Account.new
        acct = acct / '/*' #get attributes
        acct.each do |node|
          next if node.text? || node.comment? || !node.respond_to?( :name )
          account.attributes[node.name] = node.inner_html
        end
        accounts << account
      end
      
      accounts
    end
    
    def self.find(name)
      raise NoConnection unless @xml
      summary = @xml.account_summary(name)
      
      account = Account.new
      acct = (summary / 'acct/*')
      acct.each do |node|
        next if node.text? || node.comment? || !node.respond_to?( :name )
        account.attributes[node.name] = node.inner_html
      end
      
      account
    end
    
    def self.create(options)

      #TODO valid options
      @xml.create_account(options)
      find(options[:username])
    end
    
    def initialize
      self.attributes = {}
      self.writable_attributes = {}
    end
    
    def user
      self.attributes['user']
    end
    alias :name :user
    
    (@@readonly_attributes).each do |attribute|
      define_method attribute do
        self.attributes[attribute.to_s]
      end
    end

    (@@writable_attributes).each do |attribute|
      define_method attribute do
        self.writable_attributes[attribute.to_s] || self.attributes[attribute.to_s] 
      end
      define_method "#{attribute}=" do |*parameters|
        raise ArgumentError, "expected 1 parameter" unless parameters.length == 1
        self.writable_attributes[attribute.to_s] = parameters.first
      end
    end

    def password=(password)
      Account.xml.change_account_password(user, password)
    end
    
    def suspend!( reason = '')
      Account.xml.suspend_account(user, reason)
    end
    
    def unsuspend!
      Account.xml.unsuspend_account(user)    
    end
    
    def terminate!( keepdns = "n")
     Account.xml.terminate_account(user,keepdns) 
    end
    
    def package=( new_package)
      Account.xml.change_package(user, new_package)
    end
    
    def save
      #TODO create new account through Account.new Account.save
    end
    
    def update
      #TODO update an account
    end
  end
  
  class Connection
    
    attr_accessor :http
    attr_accessor :debug
    
    def initialize(host, port, username, password)
      @user = username
      @password = password
      @http = Net::HTTP.new(host, port)
    	@http.use_ssl = true
    end
    
    def get_xml(url, options)
      @http.start {|http|
        puts "REQUEST #{'/xml-api/' + url}" if debug

        req = Net::HTTP::Get.new('/xml-api/' + url)
        req.basic_auth @user, @password
        req.set_form_data(options) unless options.nil?
        response = http.request(req)
        puts response.body if debug
        response.value
        
        
        response.body
      }
    rescue => e
      raise CantConnect, e.to_s
    rescue Net::HTTPExceptions
      raise CantConnect, response.message
    rescue Timeout::Error => e
      raise CantConnect, e.to_s
    end
  end 
  
  class Xml
    
    attr_accessor :connection
    def initialize(host, port, user, pass)
      @connection = Connection.new(host,port,user,pass)
    end
    
    # Valid options for hash: 
    # username (string)
    # User name of the account. Ex: user
    # domain (string)
    # Domain name. Ex: domain.tld
    # plan (string)
    # Package to use for account creation. Ex: reseller_gold
    # pkgname (string)
    # Name of a new package to be created based on the settings used. Ex: reseller_silver
    # savepkg (boolean)
    # Save the settings used as a new package. (1 = yes, 0 = no)
    # featurelist (string)
    # Name of the feature list to be used when creating a new package. Ex: no_ftp_100mb_gold
    # quota (integer)
    # Disk space quota in MB. (0-999999, 0 is unlimited)
    # password (string)
    # Password to access cPanel. Ex: p@ss!w0rd$123
    # ip (string)
    # Whether or not the domain has a dedicated IP address. (y = Yes, n = No)
    # cgi (boolean)
    # Whether or not the domain has cgi access. (1 = Yes, 0 = No)
    # frontpage (boolean)
    # Whether or not the domain has FrontPage extensions installed. (1 = Yes, 0 = No)
    # hasshell (boolean)
    # Whether or not the domain has shell / ssh access. (1 = Yes, 0 = No)
    # contactemail (string)
    # Contact email address for the account. Ex: user@otherdomain.tld
    # cpmod (string)
    # cPanel theme name. Ex: x3
    # maxftp (string)
    # Maximum number of FTP accounts the user can create. (0-999999 | unlimited, null | 0 is unlimited)
    # maxsql (string)
    # Maximum number of SQL databases the user can create. (0-999999 | unlimited, null | 0 is unlimited)
    # maxpop (string)
    # Maximum number of email accounts the user can create. (0-999999 | unlimited, null | 0 is unlimited)
    # maxlst (string)
    # Maximum number of mailing lists the user can create. (0-999999 | unlimited, null | 0 is unlimited)
    # maxsub (string)
    # Maximum number of subdomains the user can create. (0-999999 | unlimited, null | 0 is unlimited)
    # maxpark (string)
    # Maximum number of parked domains the user can create. (0-999999 | unlimited, null | 0 is unlimited)
    # maxaddon (string)
    # Maximum number of addon domains the user can create. (0-999999 | unlimited, null | 0 is unlimited)
    # bwlimit (string)
    # Bandiwdth limit in MB. (0-999999, 0 is unlimited)
    # customip (string)
    # Specific IP address for the site.
    # language (string)
    # Language to use in the account's cPanel interface. (ex. spanish-utf8)
    # useregns (boolean)
    # Use the registered nameservers for the domain instead of the ones configured on the server. (1 = Yes, 0 = No)
    # hasuseregns (boolean)
    # Set to 1 if you are using the above option.
    # reseller (boolean)
    # Give reseller privileges to the account. (1 = Yes, 0 = No)
    def create_account(options = {})
	    data = get_xml("createacct",options)
	    data && (data / 'createacct/result').inner_html
    end
    
    def change_account_password(user, password)
      data = get_xml("passwd", {:user => user, :pass => password})
	    data && (data / 'passwd/passwd').inner_html
    end
    
    # user (string)
    # Name of user to modify the bandwidth usage (transfer) limit for.
    # bwlimit (string)
    # Bandwidth Usage (Transfer) Limit. (in MB)
    def limit_bandwidth_usage( user, bwlimit )
      data = get_xml("limitbw", {:user => user, :bwlimit => bwlimit})
      data && (data / 'limitbw/result').inner_html
    end
    alias :limit_bandwidth :limit_bandwidth_usage
    
    def list_accounts
      data = get_xml("listaccts")
      data# && (data/:acct).inner_html
    end

    # user
    # Username associated with the acount to display.
    def account_summary( user )
      data = get_xml("accountsummary", {:user => user})
      data && (data/'accountsummary/acct').inner_html
      data
    end
    
    # user
    # Name of the user to suspend.
    # reason
    # Reason for suspension.
    def suspend_account( user, reason = '' )
      data = get_xml("suspendacct", {:user => user, :reason => reason})
      data && (data/'suspendacct/result/statusmsg').inner_html
    end
    
    # user
    # Name of the user to suspend.
    def unsuspend_account( user )
      data = get_xml("unsuspendacct", {:user => user})
      data && (data / 'unsuspendacct/result/statusmsg').inner_html
    end
    
    # user (string)
    # User name to terminate.
    # keepdns (string)
    # Keep DNS entries for the domain (default is no, 1 | y = Yes, 0 | n = No, )
    def terminate_account( user, keepdns = "n")
      data = get_xml("removeacct", {:user => user, :keepdns => keepdns})
      data && (data / 'removeacct/result/rawout').inner_html
    end
    
    # user (string)
    # User name of the account to change the package for.
    # pkg (string)
    # Name of the package that the account should use.
    def change_package( user, package )
      data = get_xml("changepackage", {:user => user, :pkg => package})
      data && (data / 'changepackage/result/rawout').inner_html
    end 
    
    # list all hosting packages set up
    def list_packages
      data = get_xml('listpkgs')
      data && (data / 'listpkgs').inner_html
    end
    
    # returns a string with the host name of the WHM instance
    def hostname
      data = get_xml('gethostname')
      data && (data/:hostname).inner_html
    end
    
    # returns the WHM/cPanel version
    def version
      data = get_xml('version')
      data && (data/:version/:version).inner_html
    end
    
    # Valid options for hash: 
    # xemail (string)
    # Email address of the domain owner.
    # host (string)
    # Domain the SSL certificate is for / SSL Host.
    # country (string)
    # Country the organization is located in.
    # state (string)
    # State the organization is located in.
    # city (string)
    # City the organization is located in
    # co (string)
    # Name of the organization / company.
    # cod (string)
    # Name of the department.
    # email (string)
    # Email to send the certificate to.
    # pass (string)
    # Certificate password.
    def generate_certificate(options = {})
      data = get_xml("generatessl", options)
      #data && XmlSimple.xml_in( data.inner_html )
      #TODO I cant get this to return anything but a blank response
      ""
    end
    alias :generate_ssl_certificate :generate_certificate
    alias :generate_ssl :generate_certificate
    
    
    def get_xml(url, options = {})
      xml = Hpricot.XML(@connection.get_xml(url, options))
      if xml.at('result')
        raise CommandFailed, xml.at('result/statusmsg').inner_html if xml.at('result/status').inner_html == "0"  
      else
        raise CommandFailed, xml.at('statusmsg').inner_html if xml.at('status').inner_html == "0"  
      end
      xml
    end
    
  end
end
  
  
  
  