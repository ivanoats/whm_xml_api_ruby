module Whm #:nodoc:
  # Allows for parameter requirements and validations for methods
  module Parameters
    # Check the included hash for the included parameters.
    #
    # ==== Example
    # 
    #    class User
    #      def initialize
    #        requires!(options, :username, :password)
    #      end
    #    end
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
    
    # Checks the hash to see if the hash includes any parameter
    # which is not included in the list of valid parameters.
    #
    # ==== Example
    #
    #    class User
    #      def initialize
    #        valid_options!(options, :username)
    #      end
    #    end
    #
    #    >> User.new(:username => "josh")
    #    => #<User:0x18a1190 @username="josh">
    #
    #    >> User.new(:username => "josh", :credit_card => "5105105105105100")
    #    ArgumentError: Not a valid parameter: credit_card
    def valid_options!(hash, *params)
      keys = hash.keys
      
      keys.each do |key|
        raise ArgumentError.new("Not a valid parameter: #{key}") unless params.include?(key)
      end
    end  
  end
end