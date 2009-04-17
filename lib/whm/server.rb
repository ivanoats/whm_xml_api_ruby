module Whm #:nodoc:
  # The Server class contains all functions that can be run on a cPanel WHM server as of
  # version 11.24.2
  class Server
    include Parameters
    attr_reader :connection
    
    def initialize(options = {})
      requires!(options, :username, :password, :host)
      @connection = Whm::Connection.new(options)
      @attributes = {}
    end
    
    def accounts
      server_accounts = self.list_accounts
      
      unless server_accounts.empty?
        @accounts = []
        
        for account in server_accounts
          @accounts << Whm::Account.new(account.to_options)
        end
        
        @accounts
      else
        nil
      end
    end
    
    def resellers
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

    # Displays pertient account information for a specific account.
    #
    # ==== Options
    # * <tt>:user</tt> - Username associated with the acount to display (string)
    def account_summary(options = {})
      requires!(options, :user)
      
      data = get_xml(:url => "accountsummary", :params => options)
      data["acct"]
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
    
    # Lists all hosting packages that are available for use by 
    # the current WHM user. If the current user is a reseller, 
    # they may not see some packages that exist if those packages 
    # are not available to be used for account creation at this time.
    def list_packages
      data = get_xml(:url => "listpkgs")
      data["package"]
    end
    
    # Displays the server's hostname.
    def hostname
      return @attributes[:hostname] if @attributes[:hostname]
      
      data = get_xml(:url => "gethostname")
      @attributes.merge!(:hostname => data["hostname"])
      @attributes[:hostname]
    end
    
    # Returns the cPanel WHM version
    def version
      return @attributes[:version] if @attributes[:version]
      
      data = get_xml(:url => 'version')
      @attributes.merge!(:version => data["version"])
      @attributes[:version]
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
    
    private
    
    # Grabs the XML and parse it
    #
    # ==== Options
    # * <tt>:url</tt> - URL of the XML API function (string)
    # * <tt>:params</tt> - Passed in parameter hash (hash)
    def get_xml(options = {})
      requires!(options, :url)      
      xml = XmlSimple.xml_in(@connection.get_xml(:url => options[:url], :params => options[:params]), { 'ForceArray' => false })
      
      xml["result"].nil? ? xml : xml["result"]
    end
  end
end