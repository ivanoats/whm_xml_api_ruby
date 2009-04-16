module Whm #:nodoc:
  # Allows for parameter requirements for methods
  module RequiresParameters
    # Check the included hash for the included parameters.
    #
    # ==== Example
    #
    # <tt>:username</tt> and <tt>:password</tt> are required parameters
    #
    #    requires!(options, :username, :password)
    #
    # So, if <tt>User.new</tt> doesn't pass these parameters, an
    # ArgumentError exception is thrown.
    #
    #    >> User.new
    #    ArgumentError: Missing required parameter: username
    #
    #    >> User.new(:username => "john")
    #    ArgumentError: Missing required parameter: password
    def requires!(hash, *params)
      params.each do |param| 
        if param.is_a?(Array)
          raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first) 

          valid_options = param[1..-1]
          raise ArgumentError.new("Parameter: #{param.first} must be one of #{valid_options.to_sentence(:connector => 'or')}") unless valid_options.include?(hash[param.first])
        else
          raise ArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param) 
        end
      end
    end    
  end
end