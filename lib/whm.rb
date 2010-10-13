$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'curb'            # As opposed to Net::HTTP (for faster requests)
require 'xmlsimple'       # For simple XML parsing
require 'active_support'  # For stringifying keys, etc.
require 'parameters'      # For parameter requirements in methods
require 'validatable'     # For object validation

WHM_DIRECTORY = File.join(File.dirname(__FILE__),'whm')

require File.join(WHM_DIRECTORY,'exceptions')
require File.join(WHM_DIRECTORY,'server')
require File.join(WHM_DIRECTORY,'account')
require File.join(WHM_DIRECTORY,'package')


module Whm
  VERSION = '0.3.2'
end