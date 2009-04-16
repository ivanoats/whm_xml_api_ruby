module Whm #:nodoc:
  # The Connection class initializes a new connection with
  # the cPanel WHM server, and manages the commands back
  # and forth between the server and the wrapper.
  class Connection
    include RequiresParameters
    
    attr_reader :http
    attr_accessor :debug
    
    # Initialize the connection with WHM. Defaults to port 2087,
    # which is the default SSL WHM port.
    def initialize(options = {})
      requires!(options, 
        :username,
        :password,
        :host
      )
      
      port = options[:port] || 2087
      
      @user     = options[:username]
      @password = options[:password]
      @http     = Net::HTTP.new(options[:host], port)
      @debug    = options[:debug] || false
    	
    	@http.use_ssl = true
    	@http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    # Grabs the XML for the specified URL from WHM using
    # the initialized connection.
    def get_xml(options = {})
      requires!(options, :url)
      
      puts "WHM: Requesting /xml-api/#{options[:url]}..." if @debug
      @http.set_debug_output($stderr) if @debug
      @http.read_timeout = 60
      
      @http.start do |http|
        req = Net::HTTP::Post.new("/xml-api/#{options[:url]}")
        req.basic_auth @user, @password
        req.set_form_data(options[:params]) unless options[:params].nil?
        
        @response = http.request(req)
      end
      
      @response.body
    rescue Net::HTTPExceptions
      raise CantConnect, response.message
    rescue Timeout::Error => e
      raise CantConnect, e.to_s
    rescue => e
      raise CantConnect, e.to_s
    end
  end
end