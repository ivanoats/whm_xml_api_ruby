require 'bundler/gem_tasks'
require 'rdoc/task'

desc 'Generate documentation for whm_xml'
RDoc::Task.new do |rd|
  rd.rdoc_dir = 'html'
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.main = "README.rdoc"
  rd.title = "whm_xml -- A Ruby wrapper for cPanel's WHM XML API"
  rd.options << "--all"
end
