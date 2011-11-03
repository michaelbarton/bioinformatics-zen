require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default,:development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'nanoc3/tasks'

desc "Cleans, builds, and uploads website files"
task :up => [:clean, :build, "deploy:rsync"]

desc "Start nanoc watcher and viewer"
multitask :dev => [:watch,:view]

task :clean do
  out = File.join(File.dirname(__FILE__),'output')
  FileUtils.rm_rf out
  FileUtils.mkdir out
end

task :build do
  `nanoc compile`
end

task :watch do
  `nanoc watch`
end

task :view do
  `nanoc view`
end

namespace :heroku do

  task :clean do
    `rm -rf output`
  end

  task :build do
    `nanoc compile && git add -uf output && git commit -m "Rebuild updated site"`
  end

  task :deploy do
    `git push heroku heroku:refs/heads/master`
  end

end
