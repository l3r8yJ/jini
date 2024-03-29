# frozen_string_literal: true

require 'English'

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/version'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=2.6.8'
  s.name = 'jini'
  s.version = JiniModule::VERSION
  s.license = 'MIT'
  s.summary = 'Simple Immutable Ruby XPATH Builder'
  s.description = 'Class Jini helps you build an XPATH and then modify its parts via a simple fluent interface.'
  s.authors = ['Ivan Ivanchuck']
  s.email = 'l3r8y@duck.com'
  s.homepage = 'https://l3r8yj.github.io/jini.github/'
  s.files = `git ls-files`.split($RS)
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.add_development_dependency 'minitest', '5.16.3'
  s.add_development_dependency 'rubocop', '1.31.1'
  s.add_development_dependency 'rubocop-rspec', '2.11.1'
  s.metadata = { 'rubygems_mfa_required' => 'false' }
end
