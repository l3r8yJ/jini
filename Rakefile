require 'bundler/gem_tasks'
require 'rdoc'
require 'rubygems'
require 'rake'
require 'rake/clean'

def version
  Gem::Specification.load(Dir['*.gemspec'].first).version
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[clean test features rubocop]

require 'rake/testtask'
desc 'Run all unit tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

require 'rdoc/task'
desc 'Build RDoc documentation'
Rake::RDocTask.new do |r|
  r.rdoc_dir = 'rdoc'
  r.rdoc_files.include('README*')
  r.rdoc_files.include('lib/**/*.rb')
end

desc 'Run RuboCop on all dirs'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.fail_on_error = true
  t.requires << 'rubocop-rspec'
  t.options = ['--display-cop-names']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do
  Rake::Cleaner.cleanup_files(['coverage'])
end
Cucumber::Rake::Task.new(:'features:html') do |t|
  t.profile = 'html_report'
end
