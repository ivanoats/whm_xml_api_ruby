require 'rake'

Gem::Specification.new do |s|
  s.name = 'whm_xml'
  s.version = '0.3.0'
  s.authors = ["Ivan Storck", "Padraic McGee", "Josh Delsman"]
  s.summary = 'whm_xml is a Ruby wrapper for the cPanel Web Host Manager (WHM) XML-API'
  s.description = <<-EOF
      whm_xml is a Ruby wrapper for the cPanel Web Host Manager (WHM) XML-API
    EOF
  s.email = 'ivanoats+whm_xml@gmail.com'
  s.homepage = 'http://github.com/ivanoats/whm_xml_api_ruby'
  s.required_ruby_version = '>= 1.8.1'
  s.test_files = ['spec/server_spec.rb']  
  
  s.add_dependency('xml-simple', [">= 1.0.12"])
  s.add_dependency('activesupport', [">= 2.3.2"])
  s.add_dependency('curb', [">= 0.3.2"])
  s.add_dependency('validatable', [">= 1.6.7"])
  
  s.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
end
