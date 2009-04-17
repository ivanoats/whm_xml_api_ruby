module Whm #:nodoc:
  # The Server class initializes a new connection with the cPanel WHM server, and 
  # contains all functions that can be run on a cPanel WHM server as of version 11.24.2.
  class Server
    include Parameters

    # Hostname of the WHM server (e.g., <tt>dedicated.server.com</tt>)
    attr_reader :host
    
    # WHM XML-API username
    attr_reader :username
    
    # WHM XML-API password. Use this, or the remote key, to authenticate with the server
    attr_reader :password
    
    # WHM XML-API remote key. Use this, or the password, to authenticate with the server
    attr_reader :remote_key
    
    # If you'd like increased verbosity of commands, set this to <tt>true</tt>. Defaults to <tt>false</tt>
    attr_accessor :debug
    
    attr_accessor :attributes
    
    # Initialize the connection with WHM using the hostname, 
    # user and password/remote key. Will default to asking for 
    # a password, but remote_key is required if a password 
    # is not used.
    #
    # ==== Example
    #
    # Password authentication with debugging enabled:
    #
    #    Whm::Server.new(
    #      :host => "dedicated.server.com",
    #      :username => "root",
    #      :password => "s3cUr3!p@5sw0rD",
    #      :debug => true
    #    )
    #
    # Remote key authentication with port 8000, and SSL to off (defaults to port 2087, and SSL on):
    #
    #    Whm::Server.new(
    #      :host => "dedicated.server.com",
    #      :username => "root",
    #      :remote_key => "cf975b8930b0d0da69764c5d8dc8cf82 ...",
    #      :port => 8000,
    #      :ssl => false
    #    )
    def initialize(options = {})
      requires!(options, :host, :username)
      requires!(options, :password) unless options[:remote_key]
      
      @host       = options[:host]
      @username   = options[:username] || "root"
      @remote_key = options[:remote_key].gsub("\r\n", "") unless options[:password]
      @password   = options[:password] unless options[:remote_key]
      @debug      = options[:debug] || false
      @port       = options[:port] || 2087
      @ssl        = options[:ssl] || true
    end

    # Displays pertient account information for a specific account.
    #
    # ==== Options
    # * <tt>:user</tt> - Username associated with the acount to display (string)
    def account_summary(options = {})
      requires!(options, :user)
      
      data = get_xml(:url => "accountsummary", :params => options)
      data["acct"]
    end
    
    # Changes the password of a domain owner (cPanel) or reseller (WHM) account.
    #
    # ==== Options
    # * <tt>:user</tt> - Username of the user whose password should be changed (string)
    # * <tt>:pass</tt> - New password for that user (string)
    def change_account_password(options = {})
      requires!(options, :user, :pass)
      
      data = get_xml(:url => "passwd", :params => options)
	    data["passwd"]
    end
    
    # Changes the hosting package associated with an account.
    # Returns <tt>true</tt> if it is successful, or 
    # <tt>false</tt> if it is not.
    #
    # ==== Options
    # * <tt>:user</tt> - Username of the account to change the package for (string)
    # * <tt>:pkg</tt> - Name of the package that the account should use (string)
    def change_package(options = {})
      requires!(options, :user, :pkg)
      
      data = get_xml(:url => "changepackage", :params => options)
      data["status"] == "1" ? true : false
    end
    
    # Creates a hosting account and sets up it's associated domain information.
    #
    # ==== Options
    # * <tt>:username</tt> - Username of the account (string)
    # * <tt>:domain</tt> - Domain name (string)
    # * <tt>:pkgname</tt> - Name of a new package to be created based on the settings used (string)
    # * <tt>:savepkg</tt> - Save the settings used as a new package (boolean)
    # * <tt>:featurelist</tt> - Name of the feature list to be used when creating a new package (string)
    # * <tt>:quota</tt> - Disk space quota in MB. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:password</tt> - User's password to access cPanel (string)
    # * <tt>:ip</tt> - Whether or not the domain has a dedicated IP address, either <tt>"y"</tt> (Yes) or <tt>"n"</tt> (No) (string)
    # * <tt>:cgi</tt> - Whether or not the domain has CGI access (boolean)
    # * <tt>:frontpage</tt> - Whether or not the domain has FrontPage extensions installed (boolean)
    # * <tt>:hasshell</tt> - Whether or not the domain has shell/SSH access (boolean)
    # * <tt>:contactemail</tt> - Contact email address for the account (string)
    # * <tt>:cpmod</tt> - cPanel theme name (string)
    # * <tt>:maxftp</tt> - Maximum number of FTP accounts the user can create. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:maxsql</tt> - Maximum number of SQL databases the user can create. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:maxpop</tt> - Maximum number of email accounts the user can create. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:maxlst</tt> - Maximum number of mailing lists the user can create. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:maxsub</tt> - Maximum number of subdomains the user can create. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:maxpark</tt> - Maximum number of parked domains the user can create. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:maxaddon</tt> - Maximum number of addon domains the user can create. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:bwlimit</tt> - Bandwidth limit in MB. Must be between 0-999999, with 0 being unlimited (integer)
    # * <tt>:customip</tt> - Specific IP for the site (string)
    # * <tt>:language</tt> - Language to use in the account's cPanel interface (string)
    # * <tt>:useregns</tt> - Use the registered nameservers for the domain instead of the ones configured on the server (boolean)
    # * <tt>:hasuseregns</tt> - Must be set to <tt>1</tt> if the above <tt>:useregns</tt> is set to <tt>1</tt> (boolean)
    # * <tt>:reseller</tt> - Give reseller privileges to the account (boolean)
    def create_account(options = {})
      requires!(options, :domain, :username)
      
	    data = get_xml(:url => "createacct", :params => options)
    end
    
    # Generates an SSL certificate
    #
    # ==== Options
    # * <tt>:xemail</tt> - Email address of the domain owner (string)
    # * <tt>:host</tt> - Domain the SSL certificate is for, or the SSL host (string)
    # * <tt>:country</tt> - Country the organization is located in (string)
    # * <tt>:state</tt> - State the organization is located in (string)
    # * <tt>:city</tt> - City the organization is located in (string)
    # * <tt>:co</tt> - Name of the organization/company (string)
    # * <tt>:cod</tt> - Name of the department (string)
    # * <tt>:email</tt> - Email to send the certificate to (string)
    # * <tt>:pass</tt> - Certificate password (string)
    def generate_ssl_certificate(options = {})
      requires!(options, :city, :co, :cod, :country, :email, :host, :pass, :state, :xemail)
      data = get_xml(:url => "generatessl", :params => options)
    end
    
    # Displays the server's hostname.
    def hostname      
      data = get_xml(:url => "gethostname")
      data["hostname"]
    end
    
    # Modifies the bandwidth usage (transfer) limit for a specific account.
    #
    # ==== Options
    # * <tt>:user</tt> - Name of user to modify the bandwidth usage (transfer) limit for (string)
    # * <tt>:bwlimit</tt> - Bandwidth usage (transfer) limit in MB (string)
    def limit_bandwidth_usage(options = {})
      requires!(options, :user, :bwlimit)
      
      data = get_xml(:url => "limitbw", :params => options)
      data["bwlimit"]
    end
    
    # Lists all accounts on the server, or allows you to search for 
    # a specific account or set of accounts.
    #
    # ==== Options
    # * <tt>:searchtype</tt> - Type of account search (<tt>"domain"</tt>, <tt>"owner"</tt>, <tt>"user"</tt>, <tt>"ip"</tt> or <tt>"package"</tt>)
    # * <tt>:search</tt> - Search criteria, in Perl regular expression format (string)
    def list_accounts(options = {})
      data = get_xml(:url => "listaccts", :params => options)
      data["acct"]
    end
    
    # Lists all hosting packages that are available for use by 
    # the current WHM user. If the current user is a reseller, 
    # they may not see some packages that exist if those packages 
    # are not available to be used for account creation at this time.
    def list_packages
      data = get_xml(:url => "listpkgs")
      data["package"]
    end
    
    # Suspend an account. Returns <tt>true</tt> if it is successful, 
    # or <tt>false</tt> if it is not.
    #
    # ==== Options
    # * <tt>:user</tt> - Username to suspend (string)
    # * <tt>:reason</tt> - Reason for suspension (string)
    def suspend_account(options = {})
      requires!(options, :user, :reason)
      
      data = get_xml(:url => "suspendacct", :params => options)
      data["status"] == "1" ? true : false
    end
    
    # Terminates a hosting account. <b>Please note that this action is irreversible!</b>
    #
    # ==== Options
    # * <tt>:user</tt> - Username to terminate (string)
    # * <tt>:keepdns</tt> - Keep DNS entries for the domain ("y" or "n")
    def terminate_account(options = {})
      requires!(options, :user)
            
      data = get_xml(:url => "removeacct", :params => {
        :user => options[:user], 
        :keepdns => options[:keepdns] || "n"
      })
    end
    
    # Unsuspend a suspended account. Returns <tt>true</tt> if it
    # is successful, or <tt>false</tt> if it is not.
    #
    # ==== Options
    # * <tt>:user</tt> - Username to unsuspend (string)
    def unsuspend_account(options = {})
      requires!(options, :user)
      
      data = get_xml(:url => "unsuspendacct", :params => options)
      data["status"] == "1" ? true : false
    end
    
    # Returns the cPanel WHM version.
    def version    
      data = get_xml(:url => 'version')
      data["version"]
    end
    
    private
    
    # Grabs the XML response for a command to the server, and parses it.
    #
    # ==== Options
    # * <tt>:url</tt> - URL of the XML API function (string)
    # * <tt>:params</tt> - Passed in parameter hash (hash)
    def get_xml(options = {})
      requires!(options, :url)
      
      prefix = @ssl ? "https" : "http"
      
      request = Curl::Easy.new("#{prefix}://#{@host}:#{@port}/xml-api/#{options[:url]}") do |connection|
        puts "WHM: Requesting #{options[:url]}..." if @debug
        
        connection.userpwd = "#{@username}:#{@password}" if @password
        connection.headers["Authorization"] = "WHM #{@username}:#{@remote_key}" if @remote_key
        connection.verbose = true if @debug
        connection.timeout = 60
        
        unless options[:params].nil?
          for key, value in options[:params]
            connection.http_post(Curl::PostField.content(key.to_s, value))
          end
        end
      end
          
      if request.perform
        xml = XmlSimple.xml_in(request.body_str, { 'ForceArray' => false })
        xml["result"].nil? ? xml : xml["result"]
      end
    end
  end
end