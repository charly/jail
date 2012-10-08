$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jail/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jail"
  s.version     = Jail::VERSION
  s.authors     = ["Charles Sistovaris"]
  s.email       = ["charlysisto@gmail.com"]
  s.homepage    = "https://github.com/charly/jail"
  s.summary     = "Puts your assets in rails"
  s.description = %Q{
    Developers facility to install or remove jQuery plugins hosted on github by 
    adding proper javascripts, stylesheets and images in vendor/assets.
  }

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "github_api"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "jquery-rails"
  s.add_development_dependency "webmock"
  s.add_development_dependency "vcr"

end
