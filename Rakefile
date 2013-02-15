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

desc "Start nanoc watcher and viewer"
multitask :dev => [:watch,:view]

task :clean do
  `rm -rf output`
end

task :build => :clean do
  `nanoc compile`
end

task :watch do
  `nanoc watch`
end

task :view do
  `bundle exec rackup`
end

task :check => :build do
  exec "nanoc check html"
end

task :publish => :build do
  print "Publish changes to heroku (yes|no) ? "
  unless STDIN.gets.chomp.downcase == "yes"
    puts('Aborting.')
    exit
  end
  puts "Pushing changes ..."

  branch = "heroku-#{Time.now.to_i}"

  `git push
  git checkout -b #{branch} master &&
  git add -f output &&
  git commit -m "Rebuild updated site" &&
  git push -f heroku #{branch}:refs/heads/master &&
  git checkout master &&
  git branch -D #{branch}`

  puts "Done"
end
