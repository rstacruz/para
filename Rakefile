task :test do
  Dir['./test/*_test.rb'].each { |f| load f }
end

namespace :doc do
  desc "Build doc"
  task :build do
    system "proscribe build"
  end

  desc "Deploy doc"
  task :deploy => :build do
    system "git update-ghpages rstacruz/para -i doc/"
  end
end
