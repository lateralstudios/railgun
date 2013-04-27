$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "railgun/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "railgun"
  s.version     = Railgun::VERSION
  s.authors     = ["Tom Beynon"]
  s.email       = ["tom@lateralstudios.com"]
  s.homepage    = "http://lateralstudios.com"
  s.summary     = "Modular app platform"
  s.description = "A modular, extendable platform for your apps resources"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "jquery-rails"
  
  s.add_dependency "inherited_resources"
  s.add_dependency "simple_form"
  s.add_dependency "has_scope"
  s.add_dependency "kaminari"

  s.add_development_dependency "mysql2"
end
