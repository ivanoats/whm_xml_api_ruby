module Whm #:nodoc:
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
end