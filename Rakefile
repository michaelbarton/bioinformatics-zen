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

task :build do
  `nanoc compile`
end

task :watch do
  `nanoc watch`
end

task :view do
  `bundle exec rackup`
end

task :publish do
  print "Publish changes to heroku (yes|no) ? "
  unless STDIN.gets.chomp.downcase == "yes"
    puts('Aborting.')
    exit
  end
  puts "Pushing changes ..."

  branch = "heroku-#{Time.now.to_i}"

  `git push
  git checkout -b #{branch} master &&
  rm -rf output &&
  nanoc compile &&
  git add -f output &&
  git commit -m "Rebuild updated site" &&
  git push -f heroku #{branch}:refs/heads/master &&
  git checkout master &&
  git branch -D #{branch}`

  puts "Done"
end
