$:.push File.expand_path("../lib", __FILE__)
require 'whm/version'
require 'rake'

Gem::Specification.new do |s|
  s.name    = 'whm_xml'
  s.version = Whm::VERSION
  s.date    = Date.today.to_s
  s.require_paths = ["lib"]
  
  s.authors = ["Ivan Storck", "Padraic McGee", "Josh Delsman"]
  s.summary = 'Web Host Manager (WHM) XML-API Ruby library'
  s.description = 'The whm_xml library provides a Ruby wrapper for the cPanel Web Host Manager (WHM) XML-API'
  s.email = 'ivan@ivanstorck.com'
  s.homepage = 'http://github.com/ivanoats/whm_xml_api_ruby'
  
  s.add_dependency('xml-simple', [">= 1.0.12"])
  s.add_dependency('activesupport', [">= 2.3.2"])
  s.add_dependency('curb', [">= 0.3.2"])
  s.add_dependency('validatable', [">= 1.6.7"])
  s.add_dependency('i18n',["~> 0.6.0"])
  
  s.add_development_dependency('rspec',["~> 2.6.0"])
  s.add_development_dependency('mocha', ["~> 0.9.12"])
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rake', "~> 13.0.1")
  
  s.has_rdoc = true
  s.rdoc_options = ['--main', 'README.rdoc']
  s.rdoc_options << '--inline-source' << '--charset=UTF-8'
  s.extra_rdoc_files = ['README.rdoc']
  
  #s.files = %w(Rakefile README.rdoc lib/parameters.rb lib/whm/account.rb lib/whm/exceptions.rb lib/whm/server.rb lib/whm.rb spec/account_spec.rb spec/server_spec.rb spec/spec_helper.rb)
  s.files = FileList['lib/**/*.rb', '[A-Z]*', 'spec/**/*'].to_a
  s.test_files = %w(spec/server_spec.rb)
end

