module Whm #:nodoc:
  class CantConnect < StandardError #:nodoc:
  end
  
  class NoConnection < StandardError #:nodoc:
  end
  
  class CommandFailed < StandardError #:nodoc:
  end
end