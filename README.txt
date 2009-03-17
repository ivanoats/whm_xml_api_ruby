whmxml
    by Ivan Storck
    http://github.com/ivanoats/whm_xml_api_ruby/

== DESCRIPTION:
  
A ruby wrapper to the WHM XML API. WHM stands for Web Host Manager and is able to create/provision new cPanel web hosting accounts and other related functions. 

API is not finalized, please use with caution.  

== FEATURES/PROBLEMS:
  
* list accounts, list packages, create accounts, change passwords, etc

== SYNOPSIS:

require 'rubygems'
require 'whmxml'

* Make a connection to your whm server

  Whm::Account.xml = Whm::Xml.new('www.example.com',2087,'username','password')

* Find all accounts
  
  @accounts = Whm::Account.all

* Create a new account (see http://www.cpanel.net/plugins/xmlapi/createacct.html for valid options )   
  @account= Whm::Account.create({:username => 'name', 'domain' => 'example.com'})
  
* Find an account and make changes
  
  @account = Whm::Account.find('username')
  @account.password = "Updated Password"
  @account.suspend!("You broke the rules")
  @account.terminate!
  
* and view attributes

  @account.attributes['domain']
  @account.attributes['pkgname']
  

== REQUIREMENTS:

* hpricot

== INSTALL:

* sudo gem install whm_xml

== LICENSE:

(The MIT License)

Copyright (c) 2008 Ivan Storck

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
