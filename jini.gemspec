# frozen_string_literal: true

require 'English'
Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=2.6.8'
  s.name = 'jini'
  s.version = '1.1.5'
  s.license = 'MIT'
  s.summary = 'Simple Immutable Ruby XPATH Builder'
  s.description = 'Class Jini helps you build a XPATH and then modify its parts via a simple fluent interface.'
  s.authors = ['Ivan Ivanchuck']
  s.email = 'clicker.heroes.acg@gmail.com'
  s.homepage = 'https://github.com/l3r8yJ/jini'
  s.files = `git ls-files`.split($RS)
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md']
  s.add_development_dependency 'minitest', '5.16.3'
  s.add_development_dependency 'rubocop', '1.31.1'
  s.add_development_dependency 'rubocop-rspec', '2.11.1'
  s.metadata = { 'rubygems_mfa_required' => 'true' }
end
