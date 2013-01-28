$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "railgun/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "railgun"
  s.version     = Railgun::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Railgun."
  s.description = "TODO: Description of Railgun."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "jquery-rails"
  
  s.add_dependency "simple_form"
  s.add_dependency "has_scope"
  s.add_dependency "kaminari"

  s.add_development_dependency "mysql2"
end
