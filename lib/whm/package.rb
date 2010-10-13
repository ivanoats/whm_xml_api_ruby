module Whm
  class Package #:nodoc:
    include Parameters, Validatable
    
    validates_presence_of :username, :domain, :groups => :creation
    validates_format_of :savepkg, :with => /(1|0)/, :message => "must be 1 or 0", :groups => :creation
    
    attr_accessor :server
    attr_accessor :attributes


    def initialize(attributes = {})
      self.attributes = attributes
    end

  end
end