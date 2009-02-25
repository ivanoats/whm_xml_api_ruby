require 'test/unit'
require 'whmxml'

class TestWhmxml < Test::Unit::TestCase
  def setup
    @x = Whmxml.new('www.sustainablewebsites.com',2087,'username','password')
  end
  
  # you will have to put in the correct hostname from the server
  def test_get_host_name
    # puts @x.get_host_name
    assert_equal('trinity.nswebhost.com', @x.get_host_name)
  end
  
  # you will have to put in the correct version from the server
  def test_version
    # puts @x.version
    assert_equal('11.23.2', @x.version)
  end
  
  def test_list_packages
    puts @x.list_packages.to_yaml
    puts @x.length
    puts @x[0]['name']
  end
end