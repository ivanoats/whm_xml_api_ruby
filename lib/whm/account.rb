module Whm
  class Account #:nodoc:
    include Parameters, Validatable
    
    validates_presence_of :username, :domain, :groups => :creation
    validates_format_of :savepkg, :with => /(1|0)/, :message => "must be 1 or 0", :groups => :creation
    
    attr_accessor :server
    attr_accessor :attributes
    attr_accessor :writable_attributes

    
    @@default_attributes = {}
    @@writable_attributes = %w(username domain plan pkgname savepkg featurelist quota password ip cgi frontpage hasshell contactemail cpmod maxftp maxsql maxpop maxlst maxsub maxpark maxaddon bwlimit customip language useregns hasuseregns reseller)
    @@readonly_attributes = %w(disklimit diskused email ip owner partition plan startdate suspended suspendreason theme unix_startdate user)

    def initialize(attributes = {})
      self.attributes = attributes
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
      server.change_account_password(:user => user, :pass => password)
    end

    def suspend!( reason = '')
      server.suspend_account(:user => user, :reason => reason)
    end

    def unsuspend!
      server.unsuspend_account(:user => user)    
    end

    def terminate!( keepdns = "n")
     server.terminate_account(:user => user,:keepdns => keepdns) 
    end

    def package=( new_package)
      server.change_package(:user => user, :pkg => new_package)
    end

  end
end