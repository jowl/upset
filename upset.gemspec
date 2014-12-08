gemspec = Gem::Specification.new do |s|
  s.name        = 'upset'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Joel Segerlind'
  s.email       = 'joel@jowl.se'
  s.homepage    = 'https://github.com/jowl/upset'
  s.summary     = 'Configuration management library'
  s.description = 'Define, provision, transform, and inspect your configuration in a unified way across applications'
  s.license     = 'Apache License 2.0'

  s.files = Dir['lib/**/*.rb']
end
