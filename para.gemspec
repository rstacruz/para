require "./lib/para/version"
Gem::Specification.new do |s|
  s.name = "para"
  s.version = Para.version
  s.summary = "Super-simple parallel tests."
  s.description = "Run tests in parallel in either Test::Unit-style or RSpec-style."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/para"
  s.files = Dir["{bin,lib,test,examples}/**/*", "*.md", "Rakefile"].reject { |f| File.directory?(f) }
end
