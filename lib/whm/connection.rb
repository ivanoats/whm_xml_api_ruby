module Whm #:nodoc:
  # The Connection class initializes a new connection with the cPanel WHM server, and manages 
  # the commands back and forth between the server and the wrapper.
  class Connection
    include Parameters
    
    attr_reader   :host, :username, :password, :remote_key
    attr_accessor :debug
    
    # Initialize the connection with WHM using the full
    # URL, user and password/remote key. Will default to
    # asking for a password, but remote_key is required if
    # a password is not used.
    #
    # ==== Example
    #
    # Password authentication:
    #
    #    Whm::Connection.new(
    #      :host => "dedicated.server.com",
    #      :username => "root",
    #      :password => "s3cUr3!p@5sw0rD"
    #    )
    #
    # Remote key authentication:
    #
    #    Whm::Connection.new(
    #      :host => "dedicated.server.com",
    #      :username => "root",
    #      :remote_key => "cf975b8930b0d0da69764c5d8dc8cf82 ..."
    #    )
    def initialize(options = {})
      requires!(options, :host, :username)
      requires!(options, :password) unless options[:remote_key]
      
      @host       = options[:host]
      @username   = options[:username] || "root"
      @remote_key = options[:remote_key].gsub("\r\n", "") unless options[:password]
      @password   = options[:password] unless options[:remote_key]
      @debug      = options[:debug] || false
    end
    
    # Grabs the XML for the specified URL from WHM using
    # the initialized connection.
    def get_xml(options = {})
      requires!(options, :url)
      
      request = Curl::Easy.new("https://#{@host}:2087/xml-api/#{options[:url]}") do |connection|
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
      
      request.perform
      request.body_str
    # TODO: Fix these for cURL/curb
    #
    # rescue Net::HTTPExceptions
    #   raise CantConnect, response.message
    # rescue Timeout::Error => e
    #   raise CantConnect, e.to_s
    # rescue => e
    #   raise CantConnect, e.to_s
    end
  end
end