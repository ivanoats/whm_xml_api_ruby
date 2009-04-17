require 'rubygems'
require 'rake/rdoctask'

desc 'Generate documentation for whm_xml_api_ruby'
Rake::RDocTask.new do |rd|
  rd.rdoc_dir = 'html'
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.main = "README.rdoc"
  rd.title = "whm_xml_api_ruby -- A Ruby wrapper for cPanel's WHM"
  rd.options << "--all"
end
