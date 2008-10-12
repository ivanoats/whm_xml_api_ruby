# This is WHM_XML.rb
# It has the class WhmXml
# It is used for controlling WHM, which is a way of automating web hosting
# acccount setup, password resets, and other web hosting account info
# Copyright (C) 2008 Ivan Storck
# MIT License (see README.txt)
class Whmxml
  VERSION = '0.0.1'
  require 'rubygems'
  require 'net/https'
  require 'xmlsimple'
  require 'hpricot'
  require 'uri'

    def initialize(host, port, user, pass)
      @user = user
      @pass = pass
      @httpo = Net::HTTP.new(host, port)
    	@httpo.use_ssl = true
    end

    # returns a string with the host name of the WHM instance
    def get_host_name
      data = get_xml('gethostname')
      data && (data/:hostname).inner_html
    end


    # returns the WHM/cPanel version
    def version
      data = get_xml('version')
      data && (data/:version/:version).inner_html
    end

    # list all hosting packages set up
    def list_packages
      data = get_xml('listpkgs')
      data && XmlSimple.xml_in( data.inner_html )
    end

    # list the account specifics for a username
    def account_summary(account_user)
      data = get_xml("accountsummary?user=#{account_user}")
      data && (data/:acct).inner_html
    end

  private
    # connect to WHM
    def get_xml(url)
      @httpo.start {|http|
        req = Net::HTTP::Get.new('/xml-api/' + url)
        req.basic_auth @user, @pass
        response = http.request(req)
        if response.code =="200" and response.message =="OK" then
           # XmlSimple.xml_in(response.body)
           Hpricot.XML(response.body)
        else
           nil
        end #if response ok
        }
    end
  end