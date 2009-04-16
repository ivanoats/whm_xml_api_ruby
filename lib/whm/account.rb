require File.dirname(__FILE__) + '/connection.rb'

module Whm #:nodoc:
  # The Account class, which is a subclass of the Connection class, performs 
  # the account actions on the cPanel WHM server.
  class Account
    include RequiresParameters
    attr_accessor :attributes, :writable_attributes
    attr_reader :xml
    
    def initialize(options = {})
      requires!(options, :username, :password, :host)
      
      @attributes = {}
      @writable_attributes = {}
      @xml ||= Whm::Xml.new(
        :username => options[:username],
        :password => options[:password],
        :host => options[:host]
      )
    end
    
    #TODO make this not goofy
    @@default_attributes = {}
    @@writable_attributes = %w(username domain plan pkgname savepkg featurelist quota password ip cgi frontpage hasshell contactemail cpmod maxftp maxsql maxpop maxlst maxsub maxpark maxaddon bwlimit customip language useregns hasuseregns reseller)
    @@readonly_attributes = %w(disklimit diskused email ip owner partition plan startdate suspended suspendreason theme unix_startdate user)
    
    def all
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
end