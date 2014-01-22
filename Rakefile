require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "banktools-de/blz_downloader"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Download BLZ data file"
task :download do
  url = ENV["URL"]
  BankTools::DE::BLZDownloader.new(url).run
end
