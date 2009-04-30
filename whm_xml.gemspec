Gem::Specification.new do |s|
  s.name    = 'whm_xml'
  s.version = '0.3.1'
  s.date    = '2009-04-30'
  
  s.authors = ["Ivan Storck", "Padraic McGee", "Josh Delsman"]
  s.summary = 'Web Host Manager (WHM) XML-API Ruby library'
  s.description = 'The whm_xml library provides a Ruby wrapper for the cPanel Web Host Manager (WHM) XML-API'
  s.email = 'ivanoats+whm_xml@gmail.com'
  s.homepage = 'http://github.com/ivanoats/whm_xml_api_ruby'
  
  s.add_dependency('xml-simple', [">= 1.0.12"])
  s.add_dependency('activesupport', [">= 2.3.2"])
  s.add_dependency('curb', [">= 0.3.2"])
  s.add_dependency('validatable', [">= 1.6.7"])
  
  s.has_rdoc = true
  s.rdoc_options = ['--main', 'README.rdoc']
  s.rdoc_options << '--inline-source' << '--charset=UTF-8'
  s.extra_rdoc_files = ['README.rdoc']
  
  s.files = %w(Rakefile README.rdoc lib/parameters.rb lib/whm/account.rb lib/whm/exceptions.rb lib/whm/server.rb lib/whm.rb spec/account_spec.rb spec/server_spec.rb spec/spec_helper.rb)
  s.test_files = %w(spec/server_spec.rb)
end