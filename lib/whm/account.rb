module Whm
  class Account < Server
    include Parameters, Validatable
    
    validates_presence_of :username, :domain, :groups => :creation
    validates_format_of :savepkg, :with => /(1|0)/, :message => "must be 1 or 0", :groups => :creation
    
    def initialize
      raise "Not implemented"
    end
    
    def self.all
      raise "Not implemented"
    end
    
    def self.find
      raise "Not implemented"
    end
    
    def self.create
      raise "Not implemented"
    end

    def password
      raise "Not implemented"
    end
    
    def suspend!
      raise "Not implemented"
    end
    
    def unsuspend!
      raise "Not implemented"   
    end
    
    def terminate!
      raise "Not implemented" 
    end
    
    def package=( new_package)
      raise "Not implemented"
    end
    
    def save
      raise "Not implemented"
    end
    
    def update
      raise "Not implemented"
    end
  end
end