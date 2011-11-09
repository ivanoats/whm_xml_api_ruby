#require 'rake/dsl_definition'
require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rdoc/task'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

desc 'Generate documentation for whm_xml'
RDoc::Task.new do |rd|
  rd.rdoc_dir = 'html'
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.main = "README.rdoc"
  rd.title = "whm_xml -- A Ruby wrapper for cPanel's WHM XML API"
  rd.options << "--all"
end

task :default => :spec
