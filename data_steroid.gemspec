Gem::Specification.new do |gem|
  gem.name        = 'data_steroid'
  gem.version     = '0.5.1'
  gem.date        = '2016-10-20'
  gem.summary     = "Google Datastore ODM"
  gem.description = "Simple ODM to Google Datastore based on Mongoid"
  gem.authors     = ["Fabio Tomio"]
  gem.email       = 'fabiotomio@gmail.com'
  gem.homepage    = 'http://github.com/b2beauty/data_steroid'
  gem.license     = 'MIT'

  gem.files        = Dir["README.md", "lib/**/*"]
  gem.require_path = "lib"

  gem.required_ruby_version = ">= 2.3.0"

  gem.add_dependency 'activemodel', '~> 4.2'
  gem.add_dependency 'activesupport', '~> 4.2'
  gem.add_dependency 'coercible', '~> 1.0'
  gem.add_dependency 'google-cloud-datastore', '~> 0.20'
end