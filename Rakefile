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
