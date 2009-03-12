require 'rake'

Gem::Specification.new do |s|
  s.name = 'whm_xml'
  s.version = '0.2.0'
  s.authors = ["Ivan Storck", "Padraic McGee"]
  s.summary = 'whm_xml is a gem for accessing the WebHostManager (WHM) XML API with ruby.'
  s.description = <<-EOF
      whm_xml is a gem for accessing the WebHostManager (WHM) XML API with ruby
    EOF
  s.email = 'ivanoats+whm_xml@gmail.com'
  s.homepage = 'http://github.com/ivanoats/whm_xml_api_ruby/'
  s.required_ruby_version = '>= 1.8.1'
  s.test_files = ['spec/xml_api_spec.rb','spec/account_spec.rb']  
  s.add_dependency('hpricot', [">= 0"])
  s.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
end
