# Copyright (C) 2008-2009 Ivan Storck
# MIT License (see README.txt)

$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'net/https'
require 'xmlsimple'
require 'uri'

require 'requires_parameters'

require 'whm/account'
require 'whm/connection'
require 'whm/exceptions'
require 'whm/xml'

module Whm
  VERSION = '0.2.0'
end