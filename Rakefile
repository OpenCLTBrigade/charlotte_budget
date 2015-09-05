require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative 'lib/charlotte_budget/downloaders/open_data_portal_downloader'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :download do
  OpenDataPortalDownloader.perform
end
