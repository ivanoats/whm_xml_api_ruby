$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'net/https'
require 'xmlsimple'

require 'requires_parameters'

require 'whm/account'
require 'whm/connection'
require 'whm/exceptions'
require 'whm/xml'

module Whm
  VERSION = '0.3.0'
end